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
    let w3WAPI = What3WordsV4(apiKey:"CTF89056")
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView(
                    viewModel: ContentViewModel(w3wAPI: w3WAPI)

                )
                .modelContainer(for: [HistoryItem.self])
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

                HistoryView(
                    viewModel: ContentViewModel(w3wAPI: w3WAPI)
                )
                .tabItem {
                    Label("History", systemImage: "clock")
                }.modelContainer(for: [HistoryItem.self])
            }

        }
    }
}

