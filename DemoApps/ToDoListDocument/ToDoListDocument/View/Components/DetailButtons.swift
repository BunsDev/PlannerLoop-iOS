//
//  DetailButtons.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct DetailButtons: View {
    var task: Task
    @EnvironmentObject var tasksVM: TasksVM

    @State private var presentAlert = false

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
            //Delete task alert
            Alert(
                title: Text("Delete this task"),
                message: Text("This action is nonreversable"),
                primaryButton: .default(Text("Cancel"), action: {}),
                secondaryButton: .destructive(Text("Delete"), action: {
                    tasksVM.deleteTask(task: task)
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


