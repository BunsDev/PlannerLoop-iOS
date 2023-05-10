//
//
// NewOperationTableCell.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

// To Be scheduled Table operation cell
struct NewOperationTableCell: View {
    @ObservedObject var operation: Oprtn
    @Environment(\.managedObjectContext) var moc
    let width: CGFloat

    var body: some View {
        VStack(spacing: 5){
            HStack(spacing: 0){
                TableCell(title: operation.name ?? "", width: colWidth(tableWidth: width))
                TableCell(title: ResourceVM.shared.getResName(resID: operation.machineID) ?? "Neznámý", width: colWidth(tableWidth: width))
                TableCell(title: String(operation.priority), width: colWidth(tableWidth: width))
                TableCell(title: "\(OperationVM.shared.getDurationLabel(operation.instTime))", width: colWidth(tableWidth: width))
                TableCell(title: "\(operation.iterations) x \(OperationVM.shared.getDurationLabel(operation.iterDuration))", width: colWidth(tableWidth: width))
                TableCell(title: OperationVM.shared.getDateLabel(date: operation.deadline ?? Date()), width: colWidth(tableWidth: width), showDivider: false)
            }
            IndexButtons(operation: operation)
        }
        .padding(.vertical ,5)
        .background(Color("Background")
                        .cornerRadius(5)
                        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 1)
                        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: -1)
        )
    }
    private func colWidth(tableWidth: CGFloat) -> CGFloat {
        return max(tableWidth / 6, 0)
    }
}

