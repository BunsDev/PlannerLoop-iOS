//
//  TaskCellDescription.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TaskCellDescription: View {
    var description: String
    var due: Date
    var body: some View {
        VStack {
            HStack {
                Text("Due date:")
                    .font(.system(size: 16, weight: .semibold))
                Text(due , style: .date)
                    .font(.system(size: 16, weight: .regular))
                Text(due , style: .time)
                    .font(.system(size: 16, weight: .regular))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(description)
                .font(.system(size: 16, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)

        }
        .padding(.horizontal,10)
        .padding(.bottom,5)
    }
}
