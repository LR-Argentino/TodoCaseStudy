//
//  EditTodoServiceTests.swift
//  TodoCaseStudyTests
//
//  Created by Luca Argentino on 10.03.2025.
//

import XCTest
import TodoCaseStudy

protocol HTTPClient {
    func create(from url: URL, todo: TodoItem) async throws -> TodoItem
}

class RemoteTodoCreator {
    private let client: HTTPClient
    private let url: URL
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    func create(_ todo: TodoItem) async throws -> TodoItem? {
        return try await client.create(from: url, todo: todo)
    }
}

final class RemoteCreateTodoTests: XCTestCase {
    
    func test_init_doesNotRequestFromAnyURL() async throws {
        // GIVEN
        let todo = makeItem()
        
        // WHEN
        let (sut, client) = makeSUT()
        
        // THEN
        XCTAssertEqual(client.requests, [])
    }
    
    func test_createTodo_doesRequestRightURL() async throws {
        let url = URL(string: "http://localhost:8080/todos")!
        let todo = makeItem()
        let (sut, client) = makeSUT()
        
        _ = try await sut.create(todo)
        
        XCTAssertEqual(client.requests, [url])
    }
    
    func test_createTodoTwice_doesRequestTwice() async throws {
        let url = URL(string: "http://localhost:8080/todos")!
        let todo = makeItem()
        let (sut, client) = makeSUT()
        
        _ = try await sut.create(todo)
        _ = try await sut.create(todo)
        
        XCTAssertEqual(client.requests, [url, url])
    }
    
    
    
    // MARK: - Helpers
    private func makeSUT(_ url: URL = URL(string: "http://localhost:8080/todos")!) -> (sut: RemoteTodoCreator, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteTodoCreator(client: client, url: url)
        
        return (sut, client)
    }
    
    private func makeItem(title: String = "Test Todo",
                          note: String? = nil,
                          priority: TodoPriority = .high,
                          dueDate: Date = Date().addingTimeInterval(1000)) -> TodoItem{
        return try! TodoItem(title: title, note: note, priority: priority, dueDate: dueDate)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private(set) var requests: [URL] = []
        
        func create(from url: URL, todo: TodoCaseStudy.TodoItem) async throws -> TodoItem {
            requests.append(url)
            return todo
        }
    }
}
