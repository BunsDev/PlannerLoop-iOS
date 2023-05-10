//
//  Task.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import Foundation
import SwiftUI



class Task: Identifiable, ObservableObject, Equatable, Codable{
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    init(title: String, description: String, due: Date) {
        self.title = title
        self.description = description
        self.due = due
    }
    
    @Published var id = UUID().uuidString
    @Published var title: String
    @Published var description: String
    @Published var due: Date
    @Published var isCompleted: Bool = false
    
    enum CodingKeys: CodingKey {
        case id, title, description, due, isCompleted
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        due = try container.decode(Date.self, forKey: .due)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(due, forKey: .due)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
}



