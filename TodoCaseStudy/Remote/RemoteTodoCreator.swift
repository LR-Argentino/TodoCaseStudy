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
        case requestAlreadyInProgress
    }
    
    public init(from request: URLRequest, client: HTTPClient) {
        self.request = request
        self.client = client
    }
    
    public func create(todo: TodoItem) async throws {
        let data = try RemoteTodoItemMapper.mapToData(from: todo)
        let result = try await self.client.create(todo: data, request: self.request)
    
        guard result.statusCode != METHOD_NOT_ALLOWED else {
            throw NetworkingError.invalidMethod
        }
    }
}
