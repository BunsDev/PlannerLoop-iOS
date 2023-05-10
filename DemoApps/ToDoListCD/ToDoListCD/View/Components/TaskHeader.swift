//
//  NewTaskHeader.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TaskHeader: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var tasksVM: TasksVM
    
    //Task details to create/edit task
    @Binding var title: String
    @Binding var desc: String
    @Binding var due: Date
    var task: Task?


    var body: some View {
        HStack(spacing: 10){
            //Delete task alert
            Button(action:{self.presentationMode.wrappedValue.dismiss()}
                , label: {
                    ButtonImage(image: "chevron.left", bgColor: "Shadow")
            })
            //Header Title
            if let _ = task {
                TaskHeaderTitle(title: "Edit Task")
            } else {
                TaskHeaderTitle(title: "New Task")
            }
            //Add or Edit Button
            Button(action:{
                if let taskToEdit = task {
                    //Edit task
                    editTask(title: title, desc: desc, due: due, task: taskToEdit)
                    //Hide task details popup
                    tasksVM.hideTaskDetail()
                } else {
                    //Add task
                    createTask(title: title, desc: desc, due: due)
                }
                self.presentationMode.wrappedValue.dismiss()
            }
            , label: {
                ButtonImage(image: "checkmark", bgColor: "Accent")
            })
        }
        .padding()

    }
    func createTask(title: String, desc: String, due: Date){
        let task = Task(context: moc)
        task.title = title
        task.desc = desc
        task.due = due
        task.completed = false
        try? moc.save()
    }
    
    func editTask(title: String, desc: String, due: Date, task: Task){
        task.title = title
        task.desc = desc
        task.due = due
        try? moc.save()
    }
}




