//
//  CreateTodo.swift
//  TodoCaseStudy
//
//  Created by Luca Argentino on 27.02.2025.
//

import Foundation

public protocol CreateTodo {
    func create(todo: TodoItem) async throws
}
