//
//
// NavigationHeader.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct NavigationHeader: View {
    let text: String
    @EnvironmentObject var components: ComponentsVM
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    //Navigation bar with return button
    var body: some View {
        HStack(spacing: 10){
            Button(action:{self.presentationMode.wrappedValue.dismiss()}
                   , label: {
                    ButtonImageLabel(image: "arrow.backward", bgColor: "Accent", padding: 15, size: 20)
            })
            Text(text)
                .fontWeight(.semibold)
                .font(.title3)
                .padding(12.5)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("Typography"))
                .background(Color("ContentBackground"))
                .cornerRadius(10)
        }
    }
}

struct NavigationHeader_Previews: PreviewProvider {
    static var previews: some View {
        NavigationHeader(text: "tsratsar")
    }
}
