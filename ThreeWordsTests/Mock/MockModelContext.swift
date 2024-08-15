//
//  MockModelContext.swift
//  ThreeWordsTests
//
//  Created by Kevin on 8/14/24.
//

import Foundation
import SwiftData

class MockContext: ModelContextProtocol {
    private var items: [HistoryItem] = []

    func insert(_ item: HistoryItem) {
        items.append(item)
    }

    func save() throws {
        // No-op for testing
    }

    func fetch<T>(_ fetchDescriptor: FetchDescriptor<T>) throws -> [T] where T: HistoryItem {
        return items as! [T]
    }
}

