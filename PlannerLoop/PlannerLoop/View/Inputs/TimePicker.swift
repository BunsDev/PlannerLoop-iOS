//
//
// TimePicker.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct TimePicker: View {
    let title: String
    @Binding var seconds: String
    @Binding var minutes: String

    //View with time picker for minutes and seconds
    var body: some View {
        VStack(spacing: 5){
            Text(title)
                .fontWeight(.semibold)
                .font(.footnote)
                .foregroundColor(Color("TypographyMedium"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 5)
            HStack(spacing: 10){
                TimeLabelTextfield(label: "min", value: $minutes)
                TimeLabelTextfield(label: "sek", value: $seconds)
            }
            .frame(maxHeight: 40)
        }
        .padding(10)
        .background(Color("ContentBackground"))
        .cornerRadius(10)
        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)


    }
}

struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        TimePicker(title: "Trstartsr", seconds: .constant("0"), minutes: .constant("0"))
            .background(Color("ContentBackground"))
    }
}


