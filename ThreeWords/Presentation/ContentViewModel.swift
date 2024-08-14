import SwiftUI
import SwiftData
import W3WSwiftApi
import CoreLocation
import Combine

@MainActor
final class ContentViewModel: ObservableObject {
    //MARK: Property 
    @Published var threeWordAddress: String = ""
    @Published var resultAddress: String = ""
    @Published var historyItems: [HistoryItem] = []
    private let w3wAPI: What3WordsV4
    private var cancellables: Set<AnyCancellable> = []
    private var debouncedAddress: String = ""

    init(apiKey: String) {
       w3wAPI = What3WordsV4(apiKey: apiKey)
        // Debounce the threeWordAddress input
        $threeWordAddress
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.debouncedAddress = value
            }
            .store(in: &cancellables)
    }

    func lookupAddressIfNeeded(context: ModelContext) {
        guard !debouncedAddress.isEmpty else { return }
        lookupAddress(context: context)
    }

    func lookupAddress(context: ModelContext) {
        guard !threeWordAddress.isEmpty else { return }

        // Call the What3Words API to convert the address to coordinates and find the opposite point
        w3wAPI.convertToCoordinates(words: threeWordAddress) { square, error in
            print("con me no",error?.description ?? "")
            print("Coordinates ===>: \(String(describing: square?.coordinates?.latitude)), \(square?.coordinates?.longitude)")

        }

        let converter = Simple3WordsConverter()
        if let coordinates = converter.convertToCoordinates(words: threeWordAddress) {
            print("Coordinates: \(coordinates.latitude), \(coordinates.longitude)")

            // Calculate the opposite coordinates
            let oppositeCoordinates = CLLocationCoordinate2D(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude
            )

            // Convert the opposite coordinates back to a three-word address
            self.w3wAPI.convertTo3wa(coordinates: oppositeCoordinates,language: W3WApiLanguage(locale: "en")) { [weak self] words, error in
                guard let self = self, let words = words else {
                    print("Error converting to 3-word address: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                if let words = words.words  {
                    DispatchQueue.main.async {
                        self.resultAddress = words
                        self.addHistoryItem(address: words, context: context)
                    }
                } else {
                    print("No words returned from the API.")
                }
            }
        }
    }

    func addHistoryItem(
        address: String,
        context: ModelContext
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

    func fetchHistory(context: ModelContext) {
//        let predicate = #Predicate<HistoryItem>
        let fetchDescriptor = FetchDescriptor<HistoryItem>(
            sortBy: [SortDescriptor(\HistoryItem.timestamp, order: .reverse)]
        )

        do {
            historyItems = try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch history items: \(error.localizedDescription)")
        }
    }

}
