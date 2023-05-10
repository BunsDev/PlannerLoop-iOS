//
//
// Resources.swift
// PlannerLoop
// Main resources screen
// Created by Tomáš Tomala
//
	

import SwiftUI

struct Resources: View {
    @State var sortKey: ListSortingKey = .name
    @State var ascending: Bool = true
    @EnvironmentObject var components: ComponentsVM
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        NavigationView {
            ZStack{
                VStack(spacing: 5){
                    //Navbar
                    HStack{
                        Header(text: components.resourcesSelectedCategory.rawValue, accountDetails: $components.showSettingsSheet)
                        NavigationLink(
                            destination: AddScreen(selectedCategory: $components.resourcesSelectedCategory),
                            label: {ButtonImageLabel(image: "plus", bgColor: "Accent", padding: 15, size: 20)}
                        )
                    }
                    .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    //Categories tab
                    if horizontalSizeClass != .regular {
                        ListCategories(selected: $components.resourcesSelectedCategory, categories: [.machines,.employees]).padding(5)
                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        //Sort menu
                        SortMenu(selectedSortKey: $sortKey, selectedCategory: $components.resourcesSelectedCategory, ascending: $ascending)
                        //List
                        if components.resourcesSelectedCategory == ListCategory.employees{
                            EmployeesList(selectedCategory: $components.resourcesSelectedCategory, sortKey: $sortKey)
                        } else {
                            MachinesList(selectedCategory: $components.resourcesSelectedCategory, sortKey: $sortKey)
                        }
                        Color(.clear) //ScrollView Bottom Padding for tabbar
                            .padding(.bottom, 60)
                    }
                }
                GeometryReader { geometry in
                    //Settings sheet
                    SlideOverCard(isPresented: $components.showSettingsSheet, maxHeight: geometry.size.height, maxWidth: geometry.size.width){
                        Settings()
                    }
                }
            }
            .background(Color("Background").ignoresSafeArea())
            .hiddenNavigationBarStyle()
            .onAppear{
                if components.showSettingsSheet != true {components.showTabBar()}
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Resources_Previews: PreviewProvider {
    static var previews: some View {
        Resources()
    }
}

