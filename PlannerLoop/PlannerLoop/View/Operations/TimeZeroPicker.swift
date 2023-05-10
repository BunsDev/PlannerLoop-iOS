//
//
// TimeZeroPicker.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//

import SwiftUI

struct TimeZeroPicker: View {
    @Binding var activated : Bool
    @Binding var date : Date
    // Component to pick time zero
    var body: some View {
        HStack{
            Spacer()
            LabeledContainer(label: "Počátek rozvrhování"){
                if activated {
                    HStack{
                        Spacer()
                        DatePicker("", selection: $date, displayedComponents: [.date,.hourAndMinute])
                            .labelsHidden()
                            .accentColor(Color("AccentHigh"))
                        Spacer()
                        Image(systemName: activated ? "plus" : "info")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                            .rotationEffect(.init(degrees: activated ? 45 : 0))
                            .clipped().padding(10)
                            .background(Color("Background").cornerRadius(10))
                            .onTapGesture { withAnimation{ activated.toggle() } }
                    }
                } else {
                    Button(action:{
                        activated.toggle()
                    } , label: {
                        SimpleButton(text: "Specifikovat", color: "Accent", widthMultiplier: 2, height: 40, style: .caption)
                    })
                }
            }
            Spacer()
        }
        .frame(maxWidth: 600)
    }
}


