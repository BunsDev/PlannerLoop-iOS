//
//
// StockButton.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct CustomButton: View {
    //Number picker button
    var image: String = ""
    var text: String = ""
    var activated: Bool = false
    var body: some View {
            if(image == ""){
                Text(text)
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .frame(width: 44)
                    .frame(maxHeight: .infinity)
                    .padding(.vertical,12.5)
                    .foregroundColor(Color("Typography"))
                    .background(
                        (activated ? Color("Accent") : Color("Background"))
                            .cornerRadius(10)
                            .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
                    )
            } else {
                Image(systemName: image)
                    .resizable()
                    .foregroundColor(Color("Typography"))
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .frame(width: 14, height: 14)
                    .padding(.horizontal,15)
                    .padding(.vertical,12.5)
                    .frame(maxHeight: .infinity)
                    .background(
                        (activated ? Color("Accent") : Color("Background"))
                            .cornerRadius(10)
                            .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
                    )
            }
    }
}

