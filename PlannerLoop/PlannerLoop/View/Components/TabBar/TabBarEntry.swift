//
//
// TabBarEntry.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct TabBarEntry: View {
    let text: String, index: Int, namespace: Namespace.ID
    @Binding var selectedIndex: Int
    var body: some View {
        Button(action: {
            withAnimation(.default){
                $selectedIndex.wrappedValue = index
            }
        }, label: {
            VStack(spacing: 2) {
                Text(text)
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .foregroundColor(Color("Typography"))
                RoundedRectangle(cornerRadius: 10)
                    .fill( index == selectedIndex ? Color("Accent") : Color("Disabled"))
                    .frame(height: 3)
                    .frame(maxWidth: .infinity)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    if index == selectedIndex {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color("Background"))
                            .matchedGeometryEffect(id: "tab_background", in: namespace)
                    }
                }
            )
        })
    }
}


