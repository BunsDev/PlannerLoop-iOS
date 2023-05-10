//
//  EditTask.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala on 25/01/2022.
//

import SwiftUI

struct EditTask: View {
    //TODO
    @State var title: String = ""
    @State var description: String = ""
    @State var dueDate: Date = Date()
    var task: Task? 

    var body: some View {
        VStack {
            TaskHeader(title: $title, desc: $description, due: $dueDate, task: task)
            TaskTextfield(text: $title, label: "Title")
            TaskDatepicker(dueDate: $dueDate)
            TaskTextfield(text: $description, label: "Description")
            Spacer()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .background(Color("Background").ignoresSafeArea())
    }
    
    init(task: Task) {
        self.title = task.title ?? ""
        self.description = task.desc ?? ""
        self.dueDate = task.due ?? Date()
    }
}

