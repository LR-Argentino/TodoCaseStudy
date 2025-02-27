//
//  CreateTodoTests.swift
//  TodoCaseStudyTests
//
//  Created by Luca Argentino on 27.02.2025.
//

import XCTest
import TodoCaseStudy

final class CreateTodoTests: XCTestCase {

    
    
    func test_create_shouldCreateTodoSuccessfully()  {
        // GIVEN
        let todoItem = try! TodoItem(title: "Test Todo", priority: .high, dueDate: Date())
        let sut = TodoService()
        
        // WHEN
        sut.create(todoItem)
        
        // THEN
        XCTAssertEqual(sut.todos.count, 1)
    }

}
