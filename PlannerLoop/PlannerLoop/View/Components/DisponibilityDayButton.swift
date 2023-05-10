//
//
// DisponibilityDayButton.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
    

import SwiftUI

struct DisponibilityDayButton: View {
    //Type of the disponibility day picker
    let text: String
    let type: DisponibilityDay
    @Binding var activated: DisponibilityDay

    var body: some View {
        Button(action: {
            withAnimation{
                activated = type
            }
        }, label: {
            Text(text)
                .fontWeight(.medium)
                .font(.footnote)
                .foregroundColor(Color("Typography"))
                .padding(.horizontal,7)
                .padding(.vertical,10)
                .frame(maxWidth: .infinity)
                .background(type==activated ? Color("Accent") : Color("Background"))
                .cornerRadius(10)
        })
    }
}

struct DisponibilityDayTime: View {
    let text: String
    @Binding var activated: Bool
    @Binding var from: Date
    @Binding var to: Date
    
    var body: some View {
        
        HStack {
            Button(action: {
                activated.toggle()
            }, label: {
                //Name of the day
                Text(text)
                    .fontWeight(.medium)
                    .font(.footnote)
                    .foregroundColor(Color("Typography"))
                    .padding(11)
                    .frame(width: 50)
                    .background(activated ? Color("Accent") : Color("ContentBackground"))
                    .cornerRadius(10)
            })
            Spacer()
            if activated {
                HStack {
                    //Hours from
                    DatePicker("", selection: $from, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .accentColor(Color("AccentHigh"))
                    //Hours to
                    DatePicker("", selection: $to, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .accentColor(Color("AccentHigh"))
                }
                .padding(5)
                .background(Color("ContentBackground").cornerRadius(10))
            }
            
        }
    }
}

struct DisponibilityDayButton_Previews: PreviewProvider {
    static var previews: some View {
        DisponibilityDayButton(text: "Po", type: .monday, activated: .constant(.all))
    }
}
