//
//  DescriptionDetail.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct DescriptionDetail: View {
    var desc: String
    var body: some View {
        VStack(alignment:.leading){
            Text("Description")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(.black))
            Text(desc)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Color(.black))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .padding(.bottom, 5)
    }
}
