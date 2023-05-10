//
//  NewTask.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct NewEditTask: View {
    @State var title: String = ""
    @State var description: String = ""
    @State var dueDate: Date = Date()
    var task: Task?

    var body: some View {
        VStack {
            //Navigation Bar
            TaskHeader(title: $title, desc: $description, due: $dueDate, task: task)
            //Form
            TaskTextfield(text: $title, label: "Title")
            TaskDatepicker(dueDate: $dueDate)
            TaskTextfield(text: $description, label: "Description")
            Spacer()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .background(Color("Background").ignoresSafeArea())
    }
    
    init(task: Task? = nil) {
        if let editedTask = task {
            //Editing task
            _title = State(wrappedValue: editedTask.title )
            _description = State(wrappedValue: editedTask.description )
            _dueDate = State(wrappedValue: editedTask.due )
            self.task = editedTask
        }
    }
}

struct NewEditTask_Previews: PreviewProvider {
    static var previews: some View {
        NewEditTask()
    }
}





