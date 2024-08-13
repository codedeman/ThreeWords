//
//  ContentView.swift
//  ThreeWords
//
//  Created by Kevin on 8/13/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
          VStack {
              TextField("Enter three-word address", text: $threeWordAddress)
                  .padding()
                  .textFieldStyle(RoundedBorderTextFieldStyle())

              Button(action: lookupAddress) {
                  Text("Lookup")
                      .padding()
                      .frame(maxWidth: .infinity)
                      .background(Color.blue)
                      .foregroundColor(.white)
                      .cornerRadius(8)
              }
              .padding(.vertical)

              if !resultAddress.isEmpty {
                  Text("///\(resultAddress)")
                      .font(.title)
                      .foregroundColor(.black)
                      .padding()
                      .overlay(
                          HStack {
                              Text("///")
                                  .foregroundColor(.red)
                              Spacer()
                          }
                      )
              }

              List(historyItems) { item in
                  Text("///\(item.address)")
                      .foregroundColor(.black)
                      .overlay(
                          HStack {
                              Text("///")
                                  .foregroundColor(.red)
                              Spacer()
                          }
                      )
              }
          }
          .padding()
      }
}

#Preview {
    ContentView()
}
