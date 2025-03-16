//
//  RemoteTodoCreator.swift
//  TodoCaseStudy
//
//  Created by Luca Argentino on 16.03.2025.
//

import Foundation

public final class RemoteTodoCreator: CreateTodo {
    private let request: URLRequest
    private let client: HTTPClient
    
    private var METHOD_NOT_ALLOWED: Int {
        return 405
    }
    
    public enum NetworkingError: Swift.Error {
        case invalidMethod
        case invalidData
    }
    
    public init(from request: URLRequest, client: HTTPClient) {
        self.request = request
        self.client = client
    }
    
    public func create(todo: TodoItem) async throws {
        do {
            let result = try await self.client.create(todo: self.mapToData(from: todo), request: self.request)
            
            if result.statusCode == METHOD_NOT_ALLOWED {
                throw NetworkingError.invalidMethod
            }
        }  catch NetworkingError.invalidData {
            throw NetworkingError.invalidData
        }
    }
    
    private func mapToData(from todo: TodoItem) throws -> Data {
        let remoteTodo = RemoteTodoItem(todo: todo)
        guard let data = try? JSONEncoder().encode(remoteTodo) else {
            throw NetworkingError.invalidData
        }
        
        return data
    }
}
