//
//
// SortMenu.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
    

import SwiftUI

struct SortMenu: View {
    @Binding var selectedSortKey: ListSortingKey
    @Binding var selectedCategory: ListCategory
    @Binding var ascending: Bool

    var body: some View {
        //Pick sort key for sorting and ascending/descending
        HStack{
            AscendingButton(ascending: $ascending)
            Spacer()
            HStack(spacing: 0){
                Picker(selectedSortKey.getLabel(), selection: $selectedSortKey) {
                    ForEach(selectedCategory.getSortKeys(), id: \.self) {
                        Text($0.getLabel())
                            .fontWeight(.regular)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(Color("TypographyMedium"))
                
                Image(systemName: "arrow.up.arrow.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 15)
                    .clipped()
                    .padding(.leading, 5)
            }
            .foregroundColor(Color("TypographyMedium"))
            .font(.callout)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
    }
}



struct AscendingButton: View {
    @Binding var ascending: Bool

    var body: some View {
        Button(action: {
            withAnimation{
                ascending.toggle()
            }
        }, label: {
            HStack(spacing: 0){
                Image(systemName: "arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15, height: 15)
                    .rotationEffect(.init(degrees: ascending ? 0 : 180))
                    .clipped()
                    .padding(.trailing, 5)
                    .font(.callout)

                Text(ascending ? "Vzestupně" : "Sestupně")
                    .font(.callout)
                    .fontWeight(.regular)
            }
            .foregroundColor(Color("TypographyMedium"))
        })
    }
}
