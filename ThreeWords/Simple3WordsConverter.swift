//
//  Simple3WordsConverter.swift
//  ThreeWords
//
//  Created by Kevin on 8/14/24.
//

import Foundation
import CoreLocation

class Simple3WordsConverter {
    private let worldWidth: Double = 360.0  // Longitude range: -180 to 180
    private let worldHeight: Double = 180.0 // Latitude range: -90 to 90
    private let gridSize: Double = 3.0      // 3m x 3m grid size

    func convertToCoordinates(words: String) -> CLLocationCoordinate2D? {
        let hashValue = hashWords(words: words)
        return mapHashToCoordinates(hashValue: hashValue)
    }

    private func hashWords(words: String) -> UInt64 {
        var hashValue: UInt64 = 0
        let wordsArray = words.lowercased().split(separator: ".")

        for word in wordsArray {
            for char in word {
                hashValue = hashValue &* 31 &+ UInt64(char.asciiValue ?? 0)
            }
        }

        return hashValue
    }

    private func mapHashToCoordinates(hashValue: UInt64) -> CLLocationCoordinate2D {
        // Modulo to get within world bounds
        let latitudeOffset = Double(hashValue % UInt64(worldHeight * gridSize)) / gridSize - worldHeight / 2
        let longitudeOffset = Double(hashValue / UInt64(worldHeight * gridSize) % UInt64(worldWidth * gridSize)) / gridSize - worldWidth / 2

        return CLLocationCoordinate2D(latitude: latitudeOffset, longitude: longitudeOffset)
    }
}
