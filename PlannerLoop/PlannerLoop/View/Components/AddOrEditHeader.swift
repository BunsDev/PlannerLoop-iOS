//
//
// AddOrEditHeader.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct AddOrEditHeader: View {
    //Navigation bar with delete button
    let edit: Bool
    let editString: String
    let addString: String
    @Binding var presentAlert: Bool
    var body: some View {
        HStack{
            if edit {
                NavigationHeader(text: editString)
                Button(action: { //Delete Button
                    presentAlert = true
                }, label: {
                    ButtonImageLabel(image: "trash",  bgColor: "Danger", padding: 15, size: 20)
                })
            } else {
                NavigationHeader(text: addString)
            }
        }
        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
        .padding(.horizontal,15)
        .padding(.top,5)
    }
}


