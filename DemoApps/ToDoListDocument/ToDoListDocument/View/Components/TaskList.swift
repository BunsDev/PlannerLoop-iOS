//
//  TaskList.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TaskList: View {
    @Binding var tasks: [Task]
    @EnvironmentObject var tasksVM: TasksVM

    var body: some View {
        LazyVStack(spacing: 10){
            if tasksVM.tasksOfSelectedDay.isEmpty {
                Text("No Tasks For This Day")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(10)
                    .foregroundColor(Color("TypograghyMedium"))
            } else {
                ForEach(tasksVM.tasksOfSelectedDay){task in
                    TaskCell(task: task)
                }
            }
        }
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
