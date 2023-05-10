//
//  ButtonNeumorphic.swift
//  PlannerLoop
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct ButtonNeu: View {
    var text = "Button"
    var width: CGFloat = 300
    var body: some View {
            Text(text)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color("Typography"))
                .frame(width: width, height: 50)
                .background(
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
                )
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: Color("NeuShadowLighter"), radius: 5, x: -5, y: -5)
                .shadow(color: Color("NeuShadowDarker"), radius: 5, x: 5, y: 5)
    }
}

struct ButtonAccentNeu: View {
    var text = "Button"
    var width: CGFloat = 300
    var body: some View {
            Text(text)
                .fontWeight(.semibold)
                .font(.headline)
                .frame(minWidth: getRect().width > 750 ? (getRect().width/2.3) : (getRect().width/1.4) , alignment: .center)
                .frame(height: 50)
                .background(
                    ZStack{
                        //Lower Shadow
                        Color("Accent")
                        //Upper Shadow
                        Color("AccentLow")
                            .blur(radius: 4)
                            .offset(x: -8, y: -8)
                        
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(
                                LinearGradient(gradient: Gradient(colors: [Color("AccentHigh"), Color("AccentLow")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .padding(2)
                            .blur(radius: 2)
                    }
                )
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: Color("NeuShadowDarker"), radius: 5, x: 5, y: 5)
    }
}

struct ButtonNeumorphic_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            ButtonNeu()
            Spacer()
            ButtonAccentNeu()
            Spacer()
        }
    }
}
