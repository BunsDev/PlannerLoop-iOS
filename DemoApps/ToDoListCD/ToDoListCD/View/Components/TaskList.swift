//
//  TaskList.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TaskList: View {
    @Binding var tasks: [Task]

    var body: some View {
        LazyVStack(spacing: 15){
            if let tasksToShow = tasks {
                if tasksToShow.isEmpty {
                    Text("No Tasks For This Day")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(10)
                        .foregroundColor(Color("TypograghyMedium"))
                } else {
                    ForEach(tasks){task in
                        TaskCell(task: task)
                    }
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
