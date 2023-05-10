//
//  TaskHeaderTitle.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TaskHeaderTitle: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.system(size: 22, weight: .semibold))
            .padding(12.5)
            .frame(maxWidth: .infinity)
            .foregroundColor(Color("Typograghy"))
            .background(
                Color("ContentBackground")
            )
            .cornerRadius(15)
            .shadow(color: Color("Shadow"), radius: 10, x: 0, y: 2)
    }
}


