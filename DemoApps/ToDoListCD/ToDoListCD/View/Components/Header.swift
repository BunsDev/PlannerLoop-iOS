//
//  Header.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct Header: View {
    var date: Date
    @EnvironmentObject var tasksVM: TasksVM

    var body: some View {
        HStack(spacing: 10){
            Text(date, style: .date)
                .font(.system(size: 22, weight: .semibold))
                .padding(12.5)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("Typograghy"))
                .background(
                    Color("ContentBackground")
                )
                .cornerRadius(15)
                .shadow(color: Color("Shadow"), radius: 10, x: 0, y: 2)
                .overlay(DatePicker("", selection: $tasksVM.selectedDay).labelsHidden().opacity(0.015))

            NavigationLink(
                destination: NewEditTask(),
                label: {
                    ButtonImage(image: "plus", bgColor: "Accent")
            })
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(date: Date())


            
    }
}
