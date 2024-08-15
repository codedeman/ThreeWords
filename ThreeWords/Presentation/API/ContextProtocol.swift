//
//  ContextProtocol.swift
//  ThreeWords
//
//  Created by Kevin on 8/14/24.
//

import Foundation
import SwiftData

protocol ModelContextProtocol {
    func insert(_ item: HistoryItem)
    func save() throws
    func fetch<T: HistoryItem>(_ fetchDescriptor: FetchDescriptor<T>) throws -> [T]
}

extension ModelContext: ModelContextProtocol {}
