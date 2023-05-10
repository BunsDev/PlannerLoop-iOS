//
//  NewTaskHeader.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TaskHeader: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
                if let _ = task {
                    //Edit task
                    tasksVM.editTask(title: title, desc: desc, due: due, task: task)
                } else {
                    //Add task
                    tasksVM.createTask(title: title, desc: desc, due: due)
                }
                self.presentationMode.wrappedValue.dismiss()
            }
            , label: {
                ButtonImage(image: "checkmark", bgColor: "Accent")
            })
        }
        .padding()

    }


}




