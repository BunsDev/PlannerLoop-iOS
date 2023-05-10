//
//
// SimpleButton.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct SimpleButton: View {
    var text = "Button"
    var color = "Accent"
    //Adjust width for horizontal stack of buttons
    var widthMultiplier: CGFloat = 1
    var height: CGFloat = 50
    var style: Font = .subheadline
    
    var body: some View {
            Text(text)
                .font(style)
                .fontWeight(.semibold)
                .frame(minWidth: getRect().width > 750 ? (getRect().width/(2.3*widthMultiplier)) : (getRect().width/(1.2*widthMultiplier)), alignment: .center)
                .frame(height: height)
                .background(Color(color))
                .foregroundColor(Color("Typography"))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 0)
    }
}
