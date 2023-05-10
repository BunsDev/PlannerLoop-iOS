//
//
// NumberTextField.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI
import Combine

//Textfield for numbers only
struct NumberTextField: View {
    @Binding var value: String
    var body: some View {
        TextField("", text: $value)
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .padding(5)
            .foregroundColor(Color("Typography"))
            .frame(maxHeight: .infinity)
            .background(
                Color("Accent")
                    .cornerRadius(10)
                    .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
            )
            .keyboardType(.numberPad)
            .onReceive(Just(value)) { newValue in //https://stackoverflow.com/a/58736068/9273242
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue { self.value = filtered }
            }
    }
}

struct NumberTextField_Previews: PreviewProvider {
    static var previews: some View {
        NumberTextField(value: .constant("0"))
    }
}

