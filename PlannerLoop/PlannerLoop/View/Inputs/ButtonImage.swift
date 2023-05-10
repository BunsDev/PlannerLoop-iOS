//
//  ButtonImage.swift
//  PlannerLoop
//
//  Created by Tomáš Tomala
//

import SwiftUI


struct ButtonImageLabel: View {
    var image : String
    var bgColor : String
    var padding : CGFloat
    var size : CGFloat

    var body: some View {
        Image(systemName: image)
            .resizable()
            .foregroundColor(Color("Typography"))
            .aspectRatio(contentMode: .fit)
            .clipped()
            .frame(width: size, height: size)
            .padding(padding)
            .background(Color(bgColor))
            .cornerRadius(10)
    }
}
