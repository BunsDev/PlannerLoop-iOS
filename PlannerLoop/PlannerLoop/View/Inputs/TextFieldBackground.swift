//
//  TextFieldBackground.swift
//  PlannerLoop
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TextFieldBackground: View {
    var body: some View {
        ZStack{
            //Lower Shadow
            Color("NeuShadowDarker")
            //Upper Shadow
            Color("NeuShadowLighter")
                .blur(radius: 4)
                .offset(x: -8, y: -8)
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [Color("NeuDarker"), Color("NeuLighter")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .padding(2)
                .blur(radius: 2)
        }
    }
}
