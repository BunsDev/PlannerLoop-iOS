//
//
// LabeledDivider.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI


struct LabeledDivider: View {
    //Divider with label
    var label: String = ""
    var body: some View {
        HStack(spacing: 10) {
            Rectangle()
                .frame(height: 3)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("TypographyLow"))
                .cornerRadius(3)
            Text(label)
                .fontWeight(.semibold)
                .font(.callout)
                .foregroundColor(Color("TypographyMedium"))
            Rectangle()
                .frame(height: 3)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("TypographyLow"))
                .cornerRadius(3)
        }
        .padding(.horizontal)
    }
}
