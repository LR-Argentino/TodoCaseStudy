//
//  EditTodoServiceTests.swift
//  TodoCaseStudyTests
//
//  Created by Luca Argentino on 10.03.2025.
//

import XCTest
import TodoCaseStudy


final class RemoteCreateTodoTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURLRequest() async throws {
        let request = makeRequest()
        let (_, client) = makeSUT(with: request)
        
        
        XCTAssertEqual(client.capturedRequests, [])
    }
    
    func test_create_doesThrowInvalidMethodErrorOnWrongHttpMethod() async throws {
        var request = makeRequest()
        let (sut, _) = makeSUT(with: request, statusCode: 405)
        let todo = makeItem()
        
        request.httpMethod = "GET"
        
        do {
            try await sut.create(todo: todo)
            XCTFail("Should throw an error")
        } catch {
            XCTAssertEqual(error as? RemoteTodoCreator.NetworkingError, RemoteTodoCreator.NetworkingError.invalidMethod)
        }
    }
    
    func test_create_doesRequestRightURL() async throws {
        let url = URL(string: "www.any-url.com")!
        let request = makeRequest(from: url)
        let (sut, client) = makeSUT(with: request, statusCode: 201)
        let todo = makeItem()
        
        do {
            try await sut.create(todo: todo)
            XCTAssertEqual(client.capturedRequests.first?.url, request.url)
        } catch {
            XCTFail("Should create todo successfully, but got \(error) instead")
        }
        
    }
    
    func test_create_onlySendsOneRequest_whenCalledMultipleTimes() async throws {
        let request = makeRequest()
        let (sut, client) = makeSUT(with: request, statusCode: 201)
        let todo = makeItem()
        
        async let call1: () = sut.create(todo: todo)
        async let call2: () = sut.create(todo: todo)
        async let call3: () = sut.create(todo: todo)
        
        do {
            // Alle Requests gleichzeitig ausführen
            _ = try await [call1, call2, call3]
            XCTFail("A second or third call is expected to fail")
        } catch {
            XCTAssertEqual(error as? RemoteTodoCreator.NetworkingError, RemoteTodoCreator.NetworkingError.requestAlreadyInProgress)
        }
        
        // Sicherstellen, dass der HTTP-Client nur einen Request erhalten hat
        XCTAssertEqual(client.capturedRequests.count, 1, "Es darf nur ein Request abgesendet worden sein.")
    }

    
    // TODO: Test Payload / Request Body
    
    // TODO: Test for status code in range [200..299]
    
    // MARK: - Helpers
    
    private class HTTPClientSpy: HTTPClient {
        public var capturedRequests: [URLRequest] = []
        private let statusCode: Int
        
        init(statusCode: Int) {
            self.statusCode = statusCode
        }
        
        func create(todo: Data, request: URLRequest) async throws -> HTTPURLResponse {
            capturedRequests.append(request)
            
            
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
