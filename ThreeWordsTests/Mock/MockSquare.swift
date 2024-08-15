//
//  MockSquare.swift
//  ThreeWordsTests
//
//  Created by Kevin on 8/15/24.
//

import Foundation
import CoreLocation
import W3WSwiftCore

// Mock Square class or struct
struct MockW3WSquare: W3WSquare {
    var words: String?
    var country: W3WCountry?
    var nearestPlace: String?
    var distanceToFocus: W3WDistance?
    var language: W3WLanguage?
    var coordinates: CLLocationCoordinate2D?
    var bounds: W3WBaseBox?

    var description: String {
        return "MockW3WSquare: \(words ?? "unknown")"
    }
}
