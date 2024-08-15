//
//  LanguageSelectionView.swift
//  ThreeWords
//
//  Created by Kevin on 8/15/24.
//

import Foundation
import SwiftUI
import W3WSwiftApi

struct LanguageSelectionView: View {
    @StateObject var viewModel: ContentViewModel
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode
    
    var filteredLanguages: [W3WBaseLanguage] {
        if searchText.isEmpty {
            return viewModel.languages
        } else {
            return viewModel.languages.filter { $0.nativeName?.localizedStandardContains(searchText) ?? false }
        }
    }
    
    var body: some View {
        VStack {
            TextField("Search languages", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List(filteredLanguages, id: \.code) { language in
                Button(action: {
                    viewModel.selectedLanguage = language
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(language.nativeName ?? language.name ?? "Unknown")
                }
            }
        }
        .onAppear {
            viewModel.fetchLanguagesAvailable()
        }
    }
}

