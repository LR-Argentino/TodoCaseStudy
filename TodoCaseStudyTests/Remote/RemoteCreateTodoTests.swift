//
//  EditTodoServiceTests.swift
//  TodoCaseStudyTests
//
//  Created by Luca Argentino on 10.03.2025.
//

import XCTest
import TodoCaseStudy

public protocol HTTPClient {
    func create(todo: Data, request: URLRequest) async throws -> HTTPURLResponse
}

public class RemoteTodoCreator: CreateTodo {
    private let request: URLRequest
    private let client: HTTPClient
    
    private var METHOD_NOT_ALLOWED: Int {
        return 405
    }
    
    public enum NetworError: Swift.Error {
        case invalidMethod
    }
    
    public init(from request: URLRequest, client: HTTPClient) {
        self.request = request
        self.client = client
    }
    
    public func create(todo: TodoItem) async throws {
        let result = try await self.client.create(todo: self.mapper(todo: todo), request: self.request)
        
        if result.statusCode == METHOD_NOT_ALLOWED {
            throw NetworError.invalidMethod
        }
    }
    
    private func mapper(todo: TodoItem) -> Data {
        let remoteTodo = RemoteTodoItem(todo: todo)
        return try! JSONEncoder().encode(remoteTodo)
    }
}

final class RemoteCreateTodoTests: XCTestCase {
    func test_init_doesNotRequestDataFromURLRequest() async throws {
        let todo = try! TodoItem(title: "Test", priority: .high, dueDate: Date().addingTimeInterval(100))
        let request = makeRequest()
        let (sut, client) = makeSUT(with: request)
        
        try await sut.create(todo: todo)
        
        XCTAssertEqual(client.capturedRequests, [])
    }
    
    func test_init_doesThrowInvalidMethodErrorOnWrongHttpMethod() async throws {
        var request = makeRequest()
        let (sut, _) = makeSUT(with: request, statusCode: 405)
        let todo = makeItem()
        
        request.httpMethod = "GET"
        
        do {
            try await sut.create(todo: todo)
            XCTFail("Should throw an error")
        } catch {
            XCTAssertEqual(error as? RemoteTodoCreator.NetworError, RemoteTodoCreator.NetworError.invalidMethod)
        }
    }

    
    
    // MARK: - Helpers
    
    private class HTTPClientSpy: HTTPClient {
        public var capturedRequests: [URLRequest] = []
        private let statusCode: Int
        
        init(statusCode: Int) {
            self.statusCode = statusCode
        }
        
        func create(todo: Data, request: URLRequest) async throws -> HTTPURLResponse {
            return HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        }
    }
    
    private func makeRequest(from url: URL = URL(string: "any-url.com")!) -> URLRequest {
        return URLRequest(url: url)
    }
    
    private func makeSUT(with request: URLRequest, statusCode: Int = 200) -> (sut: RemoteTodoCreator, client: HTTPClientSpy) {
        let client = HTTPClientSpy(statusCode: statusCode)
        let sut = RemoteTodoCreator(from: request, client: client)
        return (sut, client)
    }
    
    private func makeItem(title: String = "Title", priority: TodoPriority = .low, dueDate: Date = Date().addingTimeInterval(2000)) -> TodoItem {
        return try! TodoItem(title: title, priority: priority, dueDate: dueDate)
    }
}
