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
    
    public init(todo: TodoItem) {
      self.id = todo.id
      self.title = todo.title
      self.priority = todo.priority.rawValue
      self.dueDate = todo.dueDate
      self.createdAt = todo.createdAt
      self.isComplete = todo.isComplete
      self.assignedUsers = todo.assignedUsers
    }
}
