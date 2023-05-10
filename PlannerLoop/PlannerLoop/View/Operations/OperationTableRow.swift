//
//
// OperationTableRow.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct OperationTableRow: View {
    @ObservedObject var operation: Oprtn
    let width: CGFloat
    
    var body: some View {
        VStack(spacing: 5){
            //Cell for table on large displays
            HStack(spacing: 0){
                TableCell(title: operation.name ?? "", width: colWidth(tableWidth: width))
                TableCell(title: getStartLabel(), width: colWidth(tableWidth: width))
                TableCell(title: getEndLabel(), width: colWidth(tableWidth: width))
                TableCell(title: ResourceVM.shared.getResName(resID: operation.machineID) ?? "Neznámý", width: colWidth(tableWidth: width), showDivider: false)
            }
            OperationProgressBar(operation: operation)
                .padding(.horizontal)
        }
        .padding(.vertical ,5)
        .background(Color("Background")
                        .cornerRadius(5)
                        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 1)
                        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: -1)
        )
    }
    
    private func getStartLabel() -> String{
        //Time label start of the operation
        if let start = OperationVM.getOperationStart(oper: operation){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM HH:mm"
            return dateFormatter.string(from: start)
        }
        return "Neznámo"
    }
    
    private func getEndLabel() -> String{
        //Time label end of the operation
        if let end = OperationVM.getOperationEnd(oper: operation){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM HH:mm"
            return dateFormatter.string(from: end)
        }
        return "Neznámo"
    }
    
    private func colWidth(tableWidth: CGFloat) -> CGFloat {
        return max(tableWidth / 4, 0)
    }
    
}
