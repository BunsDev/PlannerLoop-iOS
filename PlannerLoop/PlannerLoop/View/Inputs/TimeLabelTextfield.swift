//
//
// TimeLabelTextfield.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI
import Combine

//Textfield for time
struct TimeLabelTextfield: View {
    let label: String
    @Binding var value: String
    var body: some View {
        HStack(spacing: 0){
            TextField("", text: $value)
                .font(.subheadline)
                .multilineTextAlignment(.trailing)
                .padding(5)
                .padding(.vertical, 2.5)
                .frame(maxHeight: .infinity)
                .background(Color("Accent"))
                .keyboardType(.numberPad)
                .onReceive(Just(value)) { newValue in //https://stackoverflow.com/a/58736068/9273242
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue { self.value = filtered }
                }
            Text(label)
                .fontWeight(.semibold)
                .font(.footnote)
                .padding(.horizontal, 10)
        }
        .foregroundColor(Color("Typography"))
        .background(Color("Background"))
        .cornerRadius(10)
        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
    }
}
