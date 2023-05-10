//
//
// CellDetailText.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct CellDetailText: View {
    //Simple text with label: value
    let label: String
    let value: String
    var body: some View {
        HStack(spacing: 3){
            if label != "" {
                Text(label)
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .foregroundColor(Color("TypographyMedium"))
            }
            if value != "" {
                Text(value)
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color("Typography"))
            }
        }
        
        .padding(.leading, 5)
    }
}
