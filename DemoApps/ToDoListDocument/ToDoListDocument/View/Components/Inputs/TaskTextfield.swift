//
//  NewTaskTextfield.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TaskTextfield: View {
    @Binding var text: String
    var label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Text(label)
                .font(.system(size: 18, weight: .semibold))
                .padding(.horizontal,10)
                .padding(.top,10)
            ExpandingTextView(text: $text)
                .background(Color("Background"))
                .cornerRadius(10)
                .padding(.horizontal,10)
                .padding(.bottom,10)
        }
        .background(Color("ContentBackground"))
        .cornerRadius(15)
        .padding(10)
        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 2)

    }
}

