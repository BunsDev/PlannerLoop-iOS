//
//
// PriorityPicker.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
// Component in Operations form to pick priority

import SwiftUI

struct PriorityPicker: View {
    let title: String
    @Binding var value: String
    
    var body: some View {
        LabeledContainer(label: title) {
            HStack(spacing: 10){
                //Null button
                Button(action: {
                    value = "0"
                }, label: {
                    CustomButton(text: "0")
                })
                //Decrease button with longpress action
                LongPressButton(action: {
                    value = String((Int(value) ?? 0)-1)
                }, longPressAction: {
                    value = String((Int(value) ?? 0)-1)
                }, label: {
                    CustomButton(image: "chevron.backward")
                })
                // Text Field
                NumberTextField(value: $value)
                //Increase button with longpress action
                LongPressButton(action: {
                    value = String((Int(value) ?? 0)+1)
                }, longPressAction: {
                    value = String((Int(value) ?? 0)+1)
                }, label: {
                    CustomButton(image: "chevron.forward")
                })
                //Max button
                Button(action: {
                    value = "10"
                }, label: {
                    CustomButton(text: "10")
                })
                
            }
            .frame(maxHeight: 40)
        }
    }
}

struct PriorityPicker_Previews: PreviewProvider {
    static var previews: some View {
        PriorityPicker(title: "Trstartsr", value: .constant("0"))
            .background(Color("ContentBackground"))
        
    }
}
