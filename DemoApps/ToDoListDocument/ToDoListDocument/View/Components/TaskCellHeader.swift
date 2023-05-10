//
//  TaskCellHeader.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TaskCellHeader: View {
    var title: String
    var due: Date
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(due, style: .time)
                .font(.system(size: 18, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(Color("Typograghy"))
            
        }
        .padding(.horizontal,10)
        .padding(.vertical,5)
        .foregroundColor(Color("Typograghy"))
        .background(Color("Background"))
        .cornerRadius(10)
        .padding(.top,5)
        .padding(.horizontal,5)
    }
}
