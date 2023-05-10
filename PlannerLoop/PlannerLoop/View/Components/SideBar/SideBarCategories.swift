//
//
// SideBarCategories.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct SideBarCategories: View {
    @Binding var selected: ListCategory
    var categories: [ListCategory]
    @Binding var tab: Int
    let tabIndex: Int
    //List of categories in sidebar
    var body: some View {
        VStack(spacing: 0){
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    withAnimation(){
                        if tab != tabIndex { tab = tabIndex }
                        $selected.wrappedValue = category
                    }
                }, label: {
                    HStack {
                        Rectangle()
                            .fill((category == selected && tab == tabIndex) ? Color("Accent") : Color("Disabled"))
                            .frame(width: 3)
                            .frame(maxHeight: .infinity)

                        Text(category.rawValue)
                            .fontWeight(.regular)
                            .font(.subheadline)
                            .foregroundColor(Color(category == selected ? "Typography" : "TypographyMedium"))
                            .padding(.vertical,7)
                        Spacer()
                    }
                    .frame(maxHeight: 35)
                })

            }
        }
        .padding(.leading, 20)

    }
}

