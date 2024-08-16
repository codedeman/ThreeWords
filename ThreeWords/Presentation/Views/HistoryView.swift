//
//  HistoryView.swift
//  ThreeWords
//
//  Created by Kevin on 8/16/24.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.modelContext) private var context
    @StateObject var viewModel: ContentViewModel
    var body: some View {
        NavigationView {
            List(viewModel.historyItems, id: \.id) { item in
                ThreeWordAddressView(address: item.address ?? "")
            }.onAppear {
                viewModel.fetchHistory(context: context)
            }.navigationTitle("History")
        }
    }
}

#Preview {
    HistoryView(viewModel: .init(w3wAPI: MockWhat3WordsAPI()))
}
