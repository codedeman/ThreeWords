//
//  MockWhat3WordsAPI.swift
//  ThreeWordsTests
//
//  Created by Kevin on 8/15/24.
//

import Foundation
import W3WSwiftApi
import CoreLocation

class MockWhat3WordsAPI: What3WordsAPIProtocol {
    var convertToCoordinatesResult: (W3WSquare?, W3WError?)?
    var convertTo3waResult: (W3WSquare?, W3WError?)?

    func convertToCoordinates(words: String, completion: @escaping W3WSquareResponse) {
        if let result = convertToCoordinatesResult {
            completion(result.0, result.1)
        }
    }

    func convertTo3wa(coordinates: CLLocationCoordinate2D, language: W3WLanguage, completion: @escaping W3WSquareResponse) {
        if let result = convertTo3waResult {
            completion(result.0, result.1)
        }
    }
}
