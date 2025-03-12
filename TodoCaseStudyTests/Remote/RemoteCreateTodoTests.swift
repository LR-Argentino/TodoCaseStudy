//
//  EditTodoServiceTests.swift
//  TodoCaseStudyTests
//
//  Created by Luca Argentino on 10.03.2025.
//

import XCTest
import TodoCaseStudy

protocol HTTPClient {
    // TODO: Return type should be a URLResponse StatusCode or the TodoItem itselfs
    func create(todo: Data, request: URLRequest) async throws
}

class RemoteTodoCreator {
    private let request: URLRequest
    
    init(from request: URLRequest, client: HTTPClient) {
        self.request = request
    }
    
    func create(_ todo: TodoItem) {
        
    }
}

final class RemoteCreateTodoTests: XCTestCase {
    func test_init_doesNotRequestDataFromURLRequest() {
        let todo = try! TodoItem(title: "Test", priority: .high, dueDate: Date().addingTimeInterval(100))
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        let request = URLRequest(url: url)
        let client = HTTPClientSpy()
        
        let sut = RemoteTodoCreator(from: request, client: client)
        
        sut.create(todo)
        
        XCTAssertEqual(client.requests, [])
    }
    
    
    // MARK: - Helpers
    
    private class HTTPClientSpy: HTTPClient {
        public var requests: [URLRequest] = []
        
        func create(todo: Data, request: URLRequest) async throws {
            
        }        
    }
}
