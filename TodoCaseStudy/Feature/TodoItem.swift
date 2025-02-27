//
//  TodoItem.swift
//  TodoCaseStudy
//
//  Created by Luca Argentino on 26.02.2025.
//

import Foundation

public enum TodoPriority: String, CaseIterable {
    case high
    case medium
    case low
}

public struct TodoItem {
    public let id: UUID = UUID()
    public var title: String
    public var note: String?
    public var priority: TodoPriority
    public var dueDate: Date
    public var createdAt: Date
    public var isComplete: Bool = false
    public var assignedUsers: [UUID] = []
    
    
    public enum Error: Swift.Error {
        case emptyTitle
        case invalidPriority
        case invalidDueDate
    }
   
    public init(title: String, note: String? = nil, priority: TodoPriority, dueDate: Date) throws {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw Error.emptyTitle
        }
        self.title = title
        self.note = note
        self.priority = priority
        guard dueDate > Date() else {
            throw Error.invalidDueDate
        }
        self.dueDate = dueDate
        self.createdAt = Date()
    }
}
