//
//  ThreeWordsApp.swift
//  ThreeWords
//
//  Created by Kevin on 8/13/24.
//

import SwiftUI
import SwiftData

@main
struct ThreeWordsApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: ContentViewModel(apiKey: "5IN0VSD1")
            ).modelContainer(for: [HistoryItem.self])

        }
    }
}
