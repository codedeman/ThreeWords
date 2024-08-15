//
//  ThreeWordsApp.swift
//  ThreeWords
//
//  Created by Kevin on 8/13/24.
//

import SwiftUI
import SwiftData
import W3WSwiftApi
@main
struct ThreeWordsApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: ContentViewModel(w3wAPI: What3WordsV4(apiKey:"CTF89056"))
            ).modelContainer(
                for: [HistoryItem.self]
            )

        }
    }
}
