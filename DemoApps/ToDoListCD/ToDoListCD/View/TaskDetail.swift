//
//  TaskDetail.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala 
//

import SwiftUI

struct TaskDetail: View {
    var task: Task?

    var body: some View {
        VStack {
            if let selectedTask = task {
                Spacer()
                VStack {
                    //Task Details
                    DetailCell(label: "Title", content: selectedTask.title ?? "")
                        .padding(.top, 5)
                    Divider()
                    DetailCell(label: "Date", content: dayOfTheMonth(date: selectedTask.due ?? Date()))
                    Divider()
                    DetailCell(label: "Time", content: timeOfTheMonth(date: selectedTask.due ?? Date()))
                    if selectedTask.desc != nil && selectedTask.desc != "" {
                        Divider()
                        DescriptionDetail(desc: selectedTask.desc ?? "")
                    }
                }
                .background(Color(.white).opacity(0.5))
                .cornerRadius(10)
                .padding(20)
                //Edit, Delete and hide details buttons
                DetailButtons(task: task)
                Spacer()
            } else {
                Spacer()
                Text("No Tasks For This Day")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(10)
                    .foregroundColor(Color(.black))
                Spacer()
            }
        }
        .frame(maxHeight: .infinity)
        .background(Blur(style: .systemUltraThinMaterial).ignoresSafeArea())
        .padding(.top)
    }
    func timeOfTheMonth(date: Date) -> String{
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        // Convert Date to String
        return dateFormatter.string(from: date)
    }
    
    func dayOfTheMonth(date: Date) -> String{
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        // Convert Date to String
        return dateFormatter.string(from: date)
    }
}

struct TaskDetail_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}




