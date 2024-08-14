//
//  HistoryItem.swift
//  ThreeWords
//
//  Created by Kevin on 8/14/24.
//

import Foundation
import SwiftData
@Model
class HistoryItem {
    var address: String?
    @Attribute(.unique) var id: UUID?
    var timestamp: Date?
    init(address: String? = nil, id: UUID? = nil, timestamp: Date? = nil) {
        self.address = address
        self.id = id
        self.timestamp = timestamp
    }
}
