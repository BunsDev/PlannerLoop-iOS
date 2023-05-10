//
//  NewTaskDatepicker.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TaskDatepicker: View {
    @Binding var dueDate: Date
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        //Form input with datepicker
        VStack(alignment: .center, spacing: 5){
            Text("Due")
                .font(.system(size: 18, weight: .semibold))
                .padding(.horizontal,10)
                .padding(.top,10)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .center, spacing: 5){
                Text(dueDate, style: .date)
                    .font(.system(size: 18, weight: .medium))
                Text(dueDate, style: .time)
                    .font(.system(size: 18, weight: .medium))
            }
            .padding(10)
            .background(Color("Background"))
            .cornerRadius(10)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom,10)
            .overlay(DatePicker("", selection: $dueDate).labelsHidden().opacity(0.015))
        }
        .background(Color("ContentBackground"))
        .cornerRadius(15)
        .padding(10)
        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 2)
    }
}

struct TaskDatepicker_Previews: PreviewProvider {
    static var previews: some View {
        NewEditTask()
    }
}
