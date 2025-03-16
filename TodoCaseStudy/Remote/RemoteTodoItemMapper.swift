//
//  RemoteTodoItemMapper.swift
//  TodoCaseStudy
//
//  Created by Luca Argentino on 16.03.2025.
//

import Foundation

internal final class RemoteTodoItemMapper {
    
    
    static func mapToData(from todo: TodoItem) throws -> Data {
        let remoteTodo = RemoteTodoItem(todo: todo)
        
        do {
            return try JSONEncoder().encode(remoteTodo)
        } catch {
            throw RemoteTodoCreator.NetworkingError.invalidData
        }
    }
}
