//
//  TaskCell.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TaskCell: View {
    var task: Task
    @EnvironmentObject var tasksVM: TasksVM

    var body: some View {
        VStack {
            TaskCellHeader(task: task)
            TaskCellDescription(task: task)
        }
        .background(Color("ContentBackground"))
        .cornerRadius(10)
        .padding(.horizontal, 10)
        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 2)
    }
}


struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
