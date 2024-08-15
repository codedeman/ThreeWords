//
//  ThreeWordAddressView.swift
//  ThreeWords
//
//  Created by Kevin on 8/14/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: Property
    @Environment(\.modelContext) private var context
    @StateObject var viewModel: ContentViewModel
    @State private var selectedLanguage = "en"
    let languages = ["en": "English", "fr": "French", "es": "Spanish", "de": "German"]

    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Language", selection: $selectedLanguage) {
                    ForEach(languages.keys.sorted(), id: \.self) { key in
                        Text(languages[key]!).tag(key)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedLanguage) { oldValue, newValue in
                    viewModel.selectedLanguage = newValue
                }
                // TextField for entering a three-word address
                TextField(
                    "Enter three-word address",
                    text: $viewModel.threeWordAddress
                )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                // Display the result address
                if !viewModel.resultAddress.isEmpty {
                    HStack {
                        ThreeWordAddressView(address: viewModel.resultAddress).padding()
                        Spacer()
                    }
                }

                // Display the history list
                List(viewModel.historyItems, id: \.id) { item in
                    ThreeWordAddressView(address: item.address ?? "")
                }
            }
            .navigationTitle("Three Word Address")
            .onAppear(perform: {
                viewModel.fetchHistory(context: context)
            }).onChange(of: viewModel.threeWordAddress) { oldValue, newValue in
                viewModel.lookupAddress(context: context)
            }.alert(isPresented: $viewModel.showAlert, content: {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )

            })
        }
    }
}


