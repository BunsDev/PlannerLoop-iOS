//
//
// TableCell.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct TableCell: View {
    //Single cell in table row
    let title: String
    let width: CGFloat
    var showDivider: Bool = true
    var isHeader: Bool = false
    var body: some View {
        HStack(spacing: 0){
            Text(title)
                .font(.body)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: isHeader ? .center : .leading )
                .foregroundColor(Color("Typography"))
                .padding(.horizontal, 5)
            if showDivider {
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
                    .foregroundColor(Color("Disabled"))
            }
        }
        .frame(width: width, height: 40)
    }

}
