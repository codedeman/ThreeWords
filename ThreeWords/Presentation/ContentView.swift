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

                // Button to perform the lookup
                Button(action: {
                    viewModel.lookupAddress(context: context)
                }) {
                    Text("Find Opposite Address")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }

                // Display the result address
                if !viewModel.resultAddress.isEmpty {
                    Text(viewModel.resultAddress)
                        .font(.title)
                        .padding()
                }

                // Display the history list
                List(viewModel.historyItems, id: \.id) { item in
                    ThreeWordAddressView(address: item.address ?? "")
                }
            }
            .navigationTitle("Three Word Address")
            .onAppear(perform: {
                viewModel.fetchHistory(context: context)
            })
        }
    }
}


