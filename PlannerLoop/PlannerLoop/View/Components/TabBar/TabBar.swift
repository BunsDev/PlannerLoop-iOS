//
//
// TabBar.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: Int
    @Namespace private var namespace
    var body: some View {
        HStack(){
            TabBarEntry(text: "Operace", index: 0, namespace: namespace, selectedIndex: $selectedTab)
            TabBarEntry(text: "Zdroje", index: 1, namespace: namespace, selectedIndex: $selectedTab)
            TabBarEntry(text: "Rozvrh", index: 2, namespace: namespace, selectedIndex: $selectedTab)
        }
        .padding(5)
        .background(Color("ContentBackground"))
        .cornerRadius(10)
        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 0)
        .padding()
        .frame(maxWidth: 400)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(selectedTab: .constant(0))
            .frame(maxHeight:.infinity)
            .background(Color("Background"))
    }
}








