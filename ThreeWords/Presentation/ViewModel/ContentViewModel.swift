import SwiftUI
import SwiftData
import W3WSwiftApi
import CoreLocation
import Combine

final class ContentViewModel: ObservableObject {
    //MARK: Property 
    @Published var threeWordAddress: String = ""
    @Published var resultAddress: String = ""
    @Published var historyItems: [HistoryItem] = []
    @Published var showAlert: Bool = false // Property to trigger alert
    @Published var errorMessage: String?
    @Published var selectedLanguage: W3WBaseLanguage?
    @Published var languages: [W3WBaseLanguage] = []

    private var cancellables: Set<AnyCancellable> = []

    private let w3wAPI: What3WordsAPIProtocol
    private var debouncedAddress: String = ""

    init(w3wAPI: What3WordsAPIProtocol) {
        self.w3wAPI = w3wAPI
        fetchLanguagesAvailable()
        // Debounce the threeWordAddress input
        $threeWordAddress
            .debounce(
                for: .milliseconds(500),
                scheduler: DispatchSerialQueue.main
            )
            .sink { [weak self] value in
                self?.debouncedAddress = value
            }
            .store(in: &cancellables)
    }

    func lookupAddress(context: ModelContextProtocol) {
        guard !threeWordAddress.isEmpty else { return }
        showAlert = false

        // Call the What3Words API to convert the address to coordinates and find the opposite point
        w3wAPI.convertToCoordinates(words: threeWordAddress) {
            [weak self] square,
            error in
            guard let self = self,
                  let latitude = square?.coordinates?.latitude,
                  let longitude = square?.coordinates?.longitude else {
                return
            }

            // Calculate the opposite coordinates
            let oppositeCoordinates = CLLocationCoordinate2D(
                latitude: -latitude,
                longitude: longitude > 0 ? longitude - 180 : longitude + 180
            )

            // Convert the opposite coordinates back to a three-word address
            self.w3wAPI.convertTo3wa(
                coordinates: oppositeCoordinates,
                language: W3WApiLanguage(locale: self.selectedLanguage?.code ?? "")
            ) { [weak self] words, error in
                guard let self = self, let words = words else {
                    return
                }

                if let words = words.words,!words.isEmpty  {
                    print("thread" , Thread.isMainThread)
                    DispatchQueue.main.async {
                        self.resultAddress = words
                        self.addHistoryItem(address: words, context: context)
                    }
                } else {
                    print("No words returned from the API.")
                    showAlert = true
                    errorMessage = "No words returned from the API"
                }
            }
        }
    }
    //MARK: Add History when perform search 
    private func addHistoryItem(
        address: String,
        context: ModelContextProtocol
    ) {
        let newItem = HistoryItem(
            address: address,
            id: UUID(),
            timestamp: Date()
        )
        context.insert(newItem)

        do {
            try context.save()
            fetchHistory(context: context)
        } catch {
            print("Failed to save history item: \(error.localizedDescription)")
        }
    }

     func fetchHistory(context: ModelContextProtocol) {
        let fetchDescriptor = FetchDescriptor<HistoryItem>(
            sortBy: [SortDescriptor(\HistoryItem.timestamp, order: .reverse)]
        )
        do {
            historyItems = try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch history items: \(error.localizedDescription)")
        }
    }

    //MARK: Fetch Languages Available
    func fetchLanguagesAvailable() {

        w3wAPI.availableLanguages { [weak self] languages, error in
            if error != nil {
                self?.showAlert = true
                self?.errorMessage = "Unable load Language"
            }
            if let languages = languages {

                if let error = error {
                    self?.showAlert = true
                    self?.errorMessage = "Unable to load Language: \(error.localizedDescription)"
                    return
                }

                if let languages = languages as? [W3WBaseLanguage] {
                    DispatchQueue.main.async {
                        self?.languages = languages
                    }
                }
            }
        }
    }

}
