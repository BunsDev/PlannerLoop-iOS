//
//
// ListCategories.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct ListCategories: View {
    @Binding var selected: ListCategory
    var categories: [ListCategory]
    //Scroll view with available categories for particular list
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal,  showsIndicators: false){
                HStack(spacing: 0){
                    Spacer(minLength: 0)
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            withAnimation(.default){
                                $selected.wrappedValue = category
                            }
                        }, label: {
                            VStack(spacing: 2) {
                                Text(category.rawValue)
                                    .fontWeight(.semibold)
                                    .font(.subheadline)
                                    .foregroundColor(Color("Typography"))
                                RoundedRectangle(cornerRadius: 15)
                                    .fill( category == selected ? Color("Accent") : Color("Disabled"))
                                    .frame(height: 3)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal,10)
                            }
                            .padding(.vertical,5)
                            .frame(width: categories.count > 3 ? geo.size.width / 3.3 : (categories.count == 0 ? geo.size.width : geo.size.width / CGFloat(categories.count)))
                        })
                    }
                    Spacer(minLength: 0)
                }
                .background(Color("Background").cornerRadius(10))
            }
        }
        .frame(maxHeight: 35)
    }
}

struct ListCategories_Previews: PreviewProvider {
    static var previews: some View {
        ListCategories(selected: .constant(.employees), categories: [.employees,.completed])
    }
}
