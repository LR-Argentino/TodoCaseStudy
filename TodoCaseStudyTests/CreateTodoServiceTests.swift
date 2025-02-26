//
//  CreateTodoManagerTests.swift
//  TodoCaseStudyTests
//
//  Created by Luca Argentino on 26.02.2025.
//

import XCTest
import TodoCaseStudy

protocol TodoRepository {
    func save(todo: TodoItem) async throws
}

protocol TodoServiceProtocol {
    func create(todo: TodoItem) async throws
}

class TodoService: TodoServiceProtocol {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func create(todo: TodoItem) async throws {
        do {
            try await self.repository.save(todo: todo)
        } catch {
            print(error)
        }
    }
}

final class CreateTodoServiceTests: XCTestCase {
    
    func test_create_createTodoSuccessfully() async throws {
        // GIVEN
        let todo = try! TodoItem(title: "Test Todo", priority: "medium", dueDate: Date.now.addingTimeInterval(3600))
        let mockRepository = MockTodoRepository()
        let sut = TodoService(repository: mockRepository)
        
        // WHEN
        try await sut.create(todo: todo)
        
        // THEN
        XCTAssertEqual(mockRepository.todos.count, 1)
    }
    
    // MARK: - Helpers
    private class MockTodoRepository: TodoRepository {
        public var todos: [TodoItem] = []
        
        func save(todo: TodoItem) async throws {
            self.todos.append(todo)
        }
    }
}
