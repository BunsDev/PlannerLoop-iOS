//
//  TasksV.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala 
//

import SwiftUI

struct TasksView: View {
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var tasksVM: TasksVM
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void


    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    //Navigation Bar
                    Header(date: $tasksVM.selectedDay)
                        .padding()
                    //Table with daypicker and tasks
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]){
                            Section(header: DayPicker(days: $tasksVM.currentMonth, selectedDate: $tasksVM.selectedDay)){
                                TaskList(tasks: $tasksVM.tasksOfSelectedDay)
                            }
                        }
                    }
                }
                if tasksVM.showDetail {
                    TaskDetail(task: $tasksVM.selectedTask)
                        .ignoresSafeArea()
                }
            }
            .onChange(of: tasksVM.selectedDay, perform: { value in
                tasksVM.getTasksOfDay(tasksVM.selectedDay)
            })
            .background(Color("Background").ignoresSafeArea())
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(saveAction: {})
    }
}


