//
//  CreateTodo.swift
//  TodoCaseStudy
//
//  Created by Luca Argentino on 27.02.2025.
//

import Foundation

public final class CreateTodoRepository: CreateTodo  {
    private let store: PersistenceStore
    
    public enum Error: Swift.Error {
        case saveFailed
    }
    
    public init(store: PersistenceStore) {
        self.store = store
    }
    
    public func create(todo: TodoItem) async throws {
        do {
            try await self.store.save(todo: todo)
        } catch {
            throw Error.saveFailed
        }
    }
}
