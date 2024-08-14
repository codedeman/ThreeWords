import SwiftUI
import SwiftData
import W3WSwiftApi
import CoreLocation

@MainActor
final class ContentViewModel: ObservableObject {
    @Published var threeWordAddress: String = ""
    @Published var resultAddress: String = ""
    @Published var historyItems: [HistoryItem] = []

    private let w3wAPI: What3WordsV4

    init(apiKey: String) {
        self.w3wAPI = What3WordsV4(apiKey: apiKey)
    }
    @MainActor
    func lookupAddress(context: ModelContext) {
        guard !threeWordAddress.isEmpty else { return }

        // Call the What3Words API to convert the address to coordinates and find the opposite point

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
//                self.resultAddress = words.words ?? ""
//                self.addHistoryItem(address: words.words ?? "", context: context)
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
