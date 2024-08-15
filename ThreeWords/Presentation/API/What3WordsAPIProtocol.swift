//
//  What3WordsAPIProtocol.swift
//  ThreeWords
//
//  Created by Kevin on 8/15/24.
//

import Foundation
import W3WSwiftApi
import CoreLocation

protocol What3WordsAPIProtocol {
    func convertToCoordinates(words: String, completion: @escaping W3WSquareResponse)

    func convertTo3wa(coordinates: CLLocationCoordinate2D, language: W3WLanguage, completion: @escaping W3WSquareResponse)
}

extension What3WordsV4: What3WordsAPIProtocol {}
