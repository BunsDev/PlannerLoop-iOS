//
//
// Header.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct Header: View {
    
    let text: String
    @Binding var accountDetails: Bool
    @EnvironmentObject var components: ComponentsVM

    var body: some View {
        HStack(spacing: 10){
            Button(action:{
                components.hideTabBar()
                accountDetails = true
            }, label: {
                ButtonImageLabel(image: "person", bgColor: "ContentBackground", padding: 15, size: 20)
            })
            Text(text)
                .fontWeight(.semibold)
                .font(.title2)
                .padding(12.5)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("Typography"))
                .background(Color("ContentBackground"))
                .cornerRadius(10)
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(text: "Text", accountDetails: .constant(false))
    }
}
