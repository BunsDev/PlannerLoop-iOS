//
//
// NewOperationIndexButtons.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct IndexButtons: View {
    //Index button of TBS operation
    let operation: Oprtn
    var body: some View {
        HStack(){
            Button(action: {
                OperationVM.shared.lowerIndex(operation: operation)
            }, label: { ButtonImageLabel(image: "chevron.up", bgColor: "Background", padding: 12.5, size: 15)
                .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
            })
            Spacer()
            Button(action: {
                OperationVM.shared.deleteTBSOperation(operation: operation)
            }, label: { ButtonImageLabel(image: "trash", bgColor: "Danger", padding: 10, size: 20) })
            Spacer()
            NavigationLink(
                destination: OperationForm(toEdit: operation),
                label: { ButtonImageLabel(image: "slider.horizontal.3", bgColor: "Accent", padding: 10, size: 20) }
            )
            Spacer()
            Button(action: {
                OperationVM.shared.increaseIndex(operation: operation)
            }, label: { ButtonImageLabel(image: "chevron.down", bgColor: "Background", padding: 12.5, size: 15)
                .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
            })
        }
        .padding(.horizontal, 10)
        .padding(.vertical,5)
    }
}
