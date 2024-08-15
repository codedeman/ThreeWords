//
//  ThreeWordAddressView.swift
//  ThreeWords
//
//  Created by Kevin on 8/14/24.
//

import SwiftUI

struct ThreeWordAddressView: View {
    let address: String

    var body: some View {
        Text(formattedAddress)
    }

    private var formattedAddress: AttributedString {
        var attributedString = AttributedString("///\(address)")

        if let range = attributedString.range(of: "///") {
            attributedString[range].foregroundColor = .red
        }

        return attributedString
    }
}

#Preview {
    ThreeWordAddressView(address: "hanoi.say.goodbye")
}
