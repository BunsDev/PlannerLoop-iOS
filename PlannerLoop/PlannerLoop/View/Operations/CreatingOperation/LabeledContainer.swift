//
//
// LabeledContainer.swift
// PlannerLoop
//
// Created by Tomáš Tomala
// Container with label that surrounds passed view
	

import SwiftUI

struct LabeledContainer<Content: View>: View {
    let content: Content
    let label: String

    init(label: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.label = label
    }
    
    var body: some View {
        //Container with label
        VStack(spacing: 5){
            Text(label)
                .fontWeight(.semibold)
                .font(.footnote)
                .foregroundColor(Color("TypographyMedium"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 5)
            content
        }
        .padding(10)
        .background(
            Color("ContentBackground")
                .cornerRadius(10)
            .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
        )
    }
}

struct LabeledContainer_Previews: PreviewProvider {
    static var previews: some View {
        LabeledContainer(label:"Preview"){
            Text("Test")
        }
    }
}
