//
//
// OperationDetailInfo.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

//Main operation detail information
struct OperationDetailInfo: View {
    @ObservedObject var operation: Oprtn
    var body: some View {
        VStack {
            Group {
                OperationDetailCell(headline: "Název", detail: operation.name ?? "")
                Divider()
                OperationDetailCell(headline: "Status", detail: OperationStatus(rawValue: operation.status)?.getLabel() ?? "Neznámý")
                Divider()
                if let start = OperationVM.getOperationStart(oper: operation) {
                    OperationDetailCell(headline: "Začátek", detail: OperationVM.shared.getDateLabel(date: start))
                    Divider()
                }
                if let end = OperationVM.getOperationEnd(oper: operation) {
                    OperationDetailCell(headline: "Konec", detail: OperationVM.shared.getDateLabel(date: end))
                    Divider()
                }
                OperationDetailCell(headline: "Doba přípravy", detail: "\(OperationVM.shared.getDurationLabel(operation.instTime))")
            }
            Group {
                Divider()
                OperationDetailCell(headline: "Doba iterace", detail: "\(OperationVM.shared.getDurationLabel(operation.iterDuration))")
                Divider()
                OperationDetailCell(headline: "Dokončeno iterací", detail: "\(OperationVM.getIterationsCompleted(operation: operation)) / \(operation.iterations)")
                Divider()
                OperationDetailCell(headline: "Zdroj", detail: ResourceVM.shared.getResName(resID: operation.machineID) ?? "Neznámý")
            }
        }
        .padding(10)
        .background(Color("ContentBackground"))
        .cornerRadius(10)
        .padding(10)
        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
    }
}
