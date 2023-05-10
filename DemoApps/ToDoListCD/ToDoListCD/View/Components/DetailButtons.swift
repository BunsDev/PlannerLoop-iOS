//
//  DetailButtons.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct DetailButtons: View {
    var task: Task?

    @Environment(\.managedObjectContext) var moc
    //Delete task alert
    @State private var presentAlert = false
    @EnvironmentObject var tasksVM: TasksVM

    var body: some View {
        VStack {
            HStack {
                //Edit Button
                NavigationLink(
                    destination: NewEditTask(task: task),
                    label: {
                        ButtonImage(image: "slider.horizontal.3", bgColor: "Accent")
                })
                Spacer()
                //Delete Button
                Button(action: {
                    presentAlert = true
                }, label: {
                    ButtonImage(image: "trash", bgColor: "Danger")
                })
            }
            .padding(.horizontal, 30)
            //Hide details button
            Button(action: {
                tasksVM.hideTaskDetail()
            }, label: {
                ButtonImage(image: "chevron.down", bgColor: "Shadow")
            })
        }
        .alert(isPresented: $presentAlert) {
            Alert(
                title: Text("Delete this task"),
                message: Text("This action is nonreversable"),
                primaryButton: .default(Text("Cancel"), action: {}),
                secondaryButton: .destructive(Text("Delete"), action: {
                    if let taskToDelete = task {
                        moc.delete(taskToDelete)
                        try? moc.save()
                    }
                    tasksVM.hideTaskDetail()
                })
            )
        }.padding()
        
    }
}

struct DetailButtons_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}


