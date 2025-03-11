//
//  CreateTodoManagerTests.swift
//  TodoCaseStudyTests
//
//  Created by Luca Argentino on 26.02.2025.
//

import XCTest
import TodoCaseStudy


final class LocaleCreateTodoTests: XCTestCase {
    
    func test_create_createTodoSuccessfully() async throws {
        // GIVEN
        let todo = try! TodoItem(title: "Test Todo", priority: TodoPriority.low, dueDate: Date.now.addingTimeInterval(3600))
        let (sut, store) = makeSUT(result: .success((Void())))

        // WHEN
        try await sut.create(todo: todo)
        
        // THEN
        XCTAssertEqual(store.todos.count, 1)
    }
    
    func test_create_throwsErrorOnInvalidTitle() async throws {
        // GIVEN
        let (_, store) = makeSUT(result: .success((Void())))

        // WHEN
        XCTAssertThrowsError(try TodoItem(title: "", priority: TodoPriority.medium, dueDate: Date.now.addingTimeInterval(3600))) { error in
            
            // THEN
            XCTAssertEqual(error as? TodoItem.Error, TodoItem.Error.emptyTitle)
            XCTAssertEqual(store.todos.count, 0)
        }
    }
    
    func test_create_throwsErrorOnInvalidDueDate() async throws {
        let (_, store) = makeSUT(result: .success((Void())))

        // GIVEN & WHEN
        XCTAssertThrowsError(try TodoItem(title: "Cut the grass", priority: TodoPriority.medium, dueDate: Date.now.addingTimeInterval(-1))) { error in
            
            // THEN
            XCTAssertEqual(error as? TodoItem.Error, TodoItem.Error.invalidDueDate)
            XCTAssertEqual(store.todos.count, 0)
        }
    }
        
    
    func test_create_throwsSaveFailedErrorOnSave() async throws {
        // GIVEN
        let (sut, store) = makeSUT(result: .failure((NSError())))
        let todo = try! TodoItem(title: "Test Todo", priority: TodoPriority.low, dueDate: Date.now.addingTimeInterval(3600))
        
        do {
            // WHEN
            try await sut.create(todo: todo)
        } catch {
            // THEN
            XCTAssertEqual(error as? CreateTodoRepository.Error, CreateTodoRepository.Error.saveFailed)
        }
        
        XCTAssertEqual(store.todos.count, 0)
    }
    
    func test_create_createTwoTodosWhenCallingCreateTwice() async throws {
        // GIVEN
        let (sut, store) = makeSUT(result: .success((Void())))
        let todo = try! TodoItem(title: "Test Todo", priority: TodoPriority.low, dueDate: Date.now.addingTimeInterval(3600))
        
        // WHEN
        try await sut.create(todo: todo)
        try await sut.create(todo: todo)
        
        
        // THEN
        XCTAssertEqual(store.todos.count, 2)
        XCTAssertEqual(store.todos[0].title, todo.title)
        XCTAssertEqual(store.todos[1].priority, todo.priority)
    }
    
    
    // MARK: - Helpers
    
    private class PersistenceClientSpy: PersistenceStore {
        public var todos: [TodoItem] = []
        
        private let result: Result<Void, Error>
        
        init(result: Result<Void, Error>) {
            self.result = result
        }
        
        func save(todo: TodoItem) async throws {
            try result.get()
            self.todos.append(todo)
        }
    }
    
    
    private func makeSUT(result: Result<Void, Error>) -> (sut: CreateTodoRepository, store: PersistenceClientSpy) {
        let store = PersistenceClientSpy(result: result)
        let sut = CreateTodoRepository(store: store)
        
        return (sut, store)
    }
   
}
