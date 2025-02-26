//
//  CreateTodoManagerTests.swift
//  TodoCaseStudyTests
//
//  Created by Luca Argentino on 26.02.2025.
//

import XCTest
import TodoCaseStudy

final class CreateTodoServiceTests: XCTestCase {
    func test_create_createTodoSuccessfully() {
        // GIVEN
        let todo = try! TodoItem(title: "Test Todo", priority: "medium", dueDate: Date().addingTimeInterval(3600))
        let mockRepository = MockTodoRepository()
        let sut = CreateTodoManager(repository: mockRepository)
        
        // WHEN
        sut.create(todo: todo)
        
        // THEN
        XCTAssertEqual(sut.todos.count, 1)
    }
}
