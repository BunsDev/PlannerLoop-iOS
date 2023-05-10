//
//
// PickTemplate.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct Templates: View {
    @State var sortKey: ListSortingKey = ListSortingKey.name

    var body: some View {
        VStack {
            //Navigation Bar
            HStack{
                NavigationHeader(text: "Šablony")
                NavigationLink(
                    destination: AddOrEditTemplate(),
                    label: { ButtonImageLabel(image: "plus", bgColor: "Accent", padding: 15, size: 20)}
                )
            }
            .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
            .padding(.horizontal)
            .padding(.vertical, 5)
            LabeledContainer(label: "Seznam šablon") {
                //Template list
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 10){
                        DynamicRequest(sortKey: sortKey.rawValue,ascending: true, emptyListString: "Šablony nenalezeny", grid: true){ (object: Template) in
                            TemplateCell(template: object, activated: true)
                        }
                        Color(.clear).padding(.bottom, 60) //ScrollView Bottom Padding for tabbar
                    }
                    .padding(5)
                }
            }
            .padding(.horizontal, 10)

        }
        .background(Color("Background").ignoresSafeArea())
        .hiddenNavigationBarStyle()
    }
}

struct Templates_Previews: PreviewProvider {
    static var previews: some View {
        Templates()
    }
}




