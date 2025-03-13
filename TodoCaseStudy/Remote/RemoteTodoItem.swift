//
//  RemoteTodoItem.swift
//  TodoCaseStudy
//
//  Created by Luca Argentino on 13.03.2025.
//

import Foundation

public struct RemoteTodoItem: Encodable {
    public var id: UUID
    public var title: String
    public var note: String?
    public var priority: String
    public var dueDate: Date
    public var createdAt: Date
    public var isComplete: Bool = false
    public var assignedUsers: [UUID]
    
    public init(id: UUID, title: String, note: String? = nil, priority: String, dueDate: Date, createdAt: Date, isComplete: Bool, assignedUsers: [UUID]) {
        self.id = id
        self.title = title
        self.note = note
        self.priority = priority
        self.dueDate = dueDate
        self.createdAt = createdAt
        self.isComplete = isComplete
        self.assignedUsers = assignedUsers
    }
}
