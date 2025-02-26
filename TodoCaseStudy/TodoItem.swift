//
//  TodoItem.swift
//  TodoCaseStudy
//
//  Created by Luca Argentino on 26.02.2025.
//

import Foundation

enum TodoItemError: Error {
    case emptyTitle
    case invalidPriority
    case invalidDueDate
}

enum TodoPriority: String, CaseIterable {
    case high
    case medium
    case low
}

public struct TodoItem {
    public let id: UUID = UUID()
    public var title: String
    public var note: String?
    public var priority: String
    public var dueDate: Date
    public var createdAt: Date
    public var isComplete: Bool = false
    public var assignedUsers: [UUID] = []
    
    public init(title: String, note: String? = nil, priority: String, dueDate: Date) throws {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TodoItemError.emptyTitle
        }
        self.title = title
        self.note = note
        guard !priority.isEmpty && TodoPriority(rawValue: priority) != nil else {
            throw TodoItemError.invalidPriority
        }
        self.priority = priority
        guard dueDate > Date() else {
            throw TodoItemError.invalidDueDate
        }
        self.dueDate = dueDate
        self.createdAt = Date()
    }
}
