//
//  TasksV.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala 
//

import SwiftUI

struct TasksView: View {
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var tasksVM: TasksVM

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    //Navigation Bar
                    Header(date: tasksVM.selectedDay)
                        .padding()
                    //Table with daypicker and tasks
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]){
                            Section(header: DayPicker(days: $tasksVM.currentMonth, selectedDate: $tasksVM.selectedDay)){
                                LazyVStack(spacing: 15){
                                    FilteredTasks(filterKey: "due", date: tasksVM.selectedDay){ (object: Task) in
                                        TaskCell(task: object)
                                            .onTapGesture {
                                                tasksVM.showTaskDetail(task: object)
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
                if tasksVM.showDetail {
                    TaskDetail(task: tasksVM.selectedTask)
                        .ignoresSafeArea()
                }
            }
            .background(Color("Background").ignoresSafeArea())
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}


