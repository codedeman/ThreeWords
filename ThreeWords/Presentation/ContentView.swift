import SwiftUI

struct ContentView: View {

    @Environment(\.modelContext) private var context

    @StateObject var viewModel: ContentViewModel

    var body: some View {
        NavigationView {
            VStack {
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
                        ThreeWordAddressView(address: viewModel.resultAddress).padding(.leading)
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
                viewModel.lookupAddressIfNeeded(context: context)
            }
        }
    }
}


