//
//  TaskCell.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TaskCell: View {
    var task: Task
    @EnvironmentObject var tasksVM: TasksVM

    var body: some View {
        VStack {
            TaskCellHeader(title: task.title, due: task.due)
            TaskCellDescription(description: task.description, due: task.due)
        }
        .onTapGesture {
            tasksVM.showTaskDetail(task: task)
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
