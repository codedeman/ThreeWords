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
                viewModel: ContentViewModel(apiKey: "CTF89056")
            ).modelContainer(
                for: [HistoryItem.self]
            )

        }
    }
}
