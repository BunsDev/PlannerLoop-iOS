//
//  TaskCellHeader.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TaskCellHeader: View {
    @ObservedObject var task: Task
    var body: some View {
        HStack {
            Text(task.title ?? "")
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(task.due ?? Date(), style: .time)
                .font(.system(size: 18, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(Color("Typograghy"))
            
        }
        .padding(10)
        .foregroundColor(Color("Typograghy"))
        .background(Color("Background"))
        .cornerRadius(10)
        .padding(.top,5)
        .padding(.horizontal,5)
    }
}
