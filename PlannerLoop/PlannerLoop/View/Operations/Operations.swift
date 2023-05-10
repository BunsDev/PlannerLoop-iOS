//
//
// Operations.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

//Main operation for Operations section
struct Operations: View {
    @State var sortKey: ListSortingKey = .name
    @State var ascending: Bool = true
    
    @EnvironmentObject var components: ComponentsVM
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        NavigationView {
            ZStack{
                VStack(spacing: 5){
                    //Navigation bar
                    HStack{
                        Header(text: "Operace", accountDetails: $components.showSettingsSheet)
                        NavigationLink(
                            destination: NewOperations(),
                            label: {ButtonImageLabel(image: "plus", bgColor: "Accent", padding: 15, size: 20)}
                        )
                    }
                    .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    if horizontalSizeClass != .regular {
                        //Category picker
                        ListCategories(selected: $components.operationsSelectedCategory, categories: [.ongoing,.toConfirm,.completed, .scheduling])
                            .padding(5)
                    }
                    //Operations
                    OperationsList(category: $components.operationsSelectedCategory, sortKey: $sortKey, ascending: $ascending)
                }
                GeometryReader { geometry in
                    //Settings card
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

struct Operations_Previews: PreviewProvider {
    static var previews: some View {
        Operations()
    }
}
