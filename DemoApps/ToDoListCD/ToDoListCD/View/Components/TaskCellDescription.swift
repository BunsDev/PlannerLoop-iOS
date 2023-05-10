//
//  TaskCellDescription.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TaskCellDescription: View {
    @ObservedObject var task: Task
    var body: some View {
        VStack {
            HStack {
                Text("Due date:")
                    .font(.system(size: 16, weight: .semibold))
                Text(task.due ?? Date(), style: .date)
                    .font(.system(size: 16, weight: .regular))
                Text(task.due ?? Date(), style: .time)
                    .font(.system(size: 16, weight: .regular))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(task.desc ?? "")
                .font(.system(size: 16, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .padding(.horizontal,10)
        .padding(.bottom,5)
    }
}
