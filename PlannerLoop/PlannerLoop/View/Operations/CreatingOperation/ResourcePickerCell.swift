//
//
// ResourcePickerCell.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct ResourcePickerCell: View {
    var text: String
    //Cell for the resource picker 
    var body: some View {
        HStack {
            Text(text)
                .fontWeight(.semibold)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundColor(Color("Typography"))
        .padding(10)
        .background(
            Color("ContentBackground")
                .cornerRadius(10)
                .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
        )
    }
}
