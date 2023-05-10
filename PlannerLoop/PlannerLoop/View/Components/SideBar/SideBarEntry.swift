//
//
// SideBarEntry.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct SideBarEntry: View {
    let text: String
    let index: Int
    @Binding var selectedIndex: Int
    //Button in sidebar
    var body: some View {
        Button(action: {
            withAnimation(.default){
                selectedIndex = index
            }
        }, label: {
            Text(text)
                .fontWeight(.semibold)
                .font(.subheadline)
                .foregroundColor(Color(index == selectedIndex ? "Typography" : "TypographyMedium"))
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(index == selectedIndex ? "Accent" : "Background"), Color("ContentBackground")]), startPoint: .leading, endPoint: .trailing)
                    .cornerRadius(10)
                )
        })
    }
}

struct SideBarEntry_Previews: PreviewProvider {
    static var previews: some View {
        SideBarEntry(text: "Test", index: 1, selectedIndex: .constant(1))
    }
}
