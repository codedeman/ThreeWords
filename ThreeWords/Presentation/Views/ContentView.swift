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
    @State private var showingLanguageList = false

    var body: some View {
        NavigationView {
            VStack {
                // TextField for entering a three-word address
                HStack {
                    TextField(
                        "Enter three-word address",
                        text: $viewModel.threeWordAddress
                    )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: viewModel.threeWordAddress) { oldValue, newValue in
                        viewModel.lookupAddress(context: context)
                    }

                    Button(viewModel.selectedLanguage?.nativeName ?? "English") {
                        showingLanguageList.toggle()
                    }
                    .sheet(isPresented: $showingLanguageList) {
                        LanguageSelectionView(viewModel: viewModel)
                    }
                    .padding()

                }

                // Display the result address
                if !viewModel.resultAddress.isEmpty {
                    HStack {
                        ThreeWordAddressView(address: viewModel.resultAddress).padding()
                        Spacer()
                    }
                }
                Spacer()

            }
            .navigationTitle("Three Word Address")
            .alert(isPresented: $viewModel.showAlert, content: {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )

            })
        }
    }
}


#Preview {
    ContentView(viewModel: .init(w3wAPI: MockWhat3WordsAPI()))
}
