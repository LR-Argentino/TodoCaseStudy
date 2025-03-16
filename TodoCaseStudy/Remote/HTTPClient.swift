//
//  HTTPClient.swift
//  TodoCaseStudy
//
//  Created by Luca Argentino on 16.03.2025.
//

import Foundation

public protocol HTTPClient {
    func create(todo: Data, request: URLRequest) async throws -> HTTPURLResponse
}
