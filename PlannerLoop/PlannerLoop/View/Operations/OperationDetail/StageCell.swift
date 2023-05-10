//
//
// EventButton.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct EventButton: View {
    
    @ObservedObject var operation: Oprtn
    @ObservedObject var event: OprtnEvent
    @Environment(\.managedObjectContext) var moc

    //Button to confirm stage completion
    var body: some View {
            Button(action: {
                operation.objectWillChange.send() //Update the view
                OperationVM.toggleEventCompleted(event: event)
            }, label: {
                EventCell(start: event.start, end: event.end, isConfirmed: event.confirmed, isDisabled: operation.status == OperationStatus.completed.rawValue)
            })
            .disabled(operation.status == OperationStatus.completed.rawValue)
            Divider()
    }
}

struct EventCell: View {
    let start: Date?
    let end: Date?
    let isConfirmed: Bool
    let isDisabled: Bool

    //Cell with stage details

    var body: some View {
        HStack(spacing: 10) {
            VStack {
                CellDetailText(label: "Start:", value: Calendar.getDayHoursString(date: start) ?? "-")
                CellDetailText(label: "Konec:", value: Calendar.getDayHoursString(date: end) ?? "-")
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            if !isDisabled {
                ButtonImageLabel(image: "checkmark", bgColor: isConfirmed ? "Accent" : "Disabled", padding: 10, size: 15)
            }
        }
        .padding(.vertical, 5)
    }
}
