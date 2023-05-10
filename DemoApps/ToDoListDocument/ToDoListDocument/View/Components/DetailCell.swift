//
//  DetailCell.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct DetailCell: View {
    //Single cell in task detail
    var label: String
    var content: String
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(.black))
            Spacer()
            Text(content)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(.black))
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct DetailCell_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
