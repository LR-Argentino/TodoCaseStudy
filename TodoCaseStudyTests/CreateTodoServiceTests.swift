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
        let todo = try! TodoItem(title: "Test Todo", priority: TodoPriority.low, dueDate: Date.now.addingTimeInterval(3600))
        let mockRepository = MockTodoRepository()
        let sut = TodoService(repository: mockRepository)
        
        // WHEN
        try await sut.create(todo: todo)
        
        // THEN
        XCTAssertEqual(mockRepository.todos.count, 1)
    }
    
    func test_create_throwsErrorOnInvalidTitle() async throws {
        // GIVEN
        let mockRepository = MockTodoRepository()
        
        // WHEN
        XCTAssertThrowsError(try TodoItem(title: "", priority: TodoPriority.medium, dueDate: Date.now.addingTimeInterval(3600))) { error in
            
            // THEN
            XCTAssertEqual(error as? TodoItem.Error, TodoItem.Error.emptyTitle)
            XCTAssertEqual(mockRepository.todos.count, 0)
        }
    }
    
    func test_create_throwsErrorOnInvalidDueDate() async throws {
        let mockRepository = MockTodoRepository()
        
        // WHEN
        XCTAssertThrowsError(try TodoItem(title: "Cut the grass", priority: TodoPriority.medium, dueDate: Date.now.addingTimeInterval(-1))) { error in
            
            // THEN
            XCTAssertEqual(error as? TodoItem.Error, TodoItem.Error.invalidDueDate)
            XCTAssertEqual(mockRepository.todos.count, 0)
        }
    }
        
    
    // MARK: - Helpers
    private class MockTodoRepository: TodoRepository {
        public var todos: [TodoItem] = []
        
        func save(todo: TodoItem) async throws {
            self.todos.append(todo)
        }
    }
}
