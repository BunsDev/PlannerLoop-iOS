//
//
// NumberPicker.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct NumberPicker: View {
    let title: String
    @Binding var value: String
    //Picker with number textfield and lower/higher buttons
    var body: some View {
        LabeledContainer(label: title) {
            HStack(spacing: 20){
                NumberTextField(value: $value)
                LongPressButton(action: {
                    value = String((Int(value) ?? 0)-1)
                }, longPressAction: {
                    value = String((Int(value) ?? 0)-1)
                }, label: {
                    CustomButton(image: "chevron.backward")
                })

                LongPressButton(action: {
                    value = String((Int(value) ?? 0)+1)
                }, longPressAction: {
                    value = String((Int(value) ?? 0)+1)
                }, label: {
                    CustomButton(image: "chevron.forward")
                })
            }
            .frame(maxHeight: 40)
        }
    }
}

struct NumberPicker_Previews: PreviewProvider {
    static var previews: some View {
        NumberPicker(title: "Trstartsr", value: .constant("0"))
            .background(Color("ContentBackground"))

    }
}


