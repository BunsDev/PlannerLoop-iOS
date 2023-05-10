//
//
// SideBar.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct SideBar: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var components: ComponentsVM
    //Sidebar view
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            VStack(alignment: .leading, spacing: 0){
                SideBarEntry(text: "Operace", index: 0, selectedIndex: $selectedTab)
                SideBarCategories(selected: $components.operationsSelectedCategory, categories: [.ongoing,.toConfirm,.completed, .scheduling], tab: $selectedTab, tabIndex: 0)
            }
            VStack(alignment: .leading, spacing: 0){
                SideBarEntry(text: "Zdroje", index: 1, selectedIndex: $selectedTab)
                SideBarCategories(selected: $components.resourcesSelectedCategory,categories: [.machines,.employees], tab: $selectedTab, tabIndex: 1)
            }
            SideBarEntry(text: "Rozvrh", index: 2, selectedIndex: $selectedTab)
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .frame(width: 140)
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .background(
            Color("ContentBackground")
                .cornerRadius(10, corners: [.topRight, .bottomRight])
                .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 0)
        )
        .padding(.trailing, 5)

    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar(selectedTab: .constant(1))
    }
}
