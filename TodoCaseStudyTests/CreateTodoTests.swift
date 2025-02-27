//
//  CreateTodoTests.swift
//  TodoCaseStudyTests
//
//  Created by Luca Argentino on 27.02.2025.
//

import XCTest
import TodoCaseStudy

class TodoService {
    public var todos: [TodoItem] = []
    
    init() {
    }
    
    func create(_ todoItem: TodoItem) {
        todos.append(todoItem)
    }
}

final class CreateTodoTests: XCTestCase {
    
    func test_create_shouldCreateTodoSuccessfully()  {
        // GIVEN
        let todoItem = try! TodoItem(title: "Test Todo", priority: TodoPriority.high, dueDate: Date().addingTimeInterval(1000))
        let sut = TodoService()
        
        // WHEN
        sut.create(todoItem)
        
        // THEN
        XCTAssertEqual(sut.todos.count, 1)
    }

}
