//
//  PersistenceStore.swift
//  TodoCaseStudy
//
//  Created by Luca Argentino on 27.02.2025.
//

import Foundation

public protocol PersistenceStore {
    func save(todo: TodoItem) async throws
}
