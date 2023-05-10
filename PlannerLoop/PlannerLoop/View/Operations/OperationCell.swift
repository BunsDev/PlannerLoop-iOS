//
//
// OperationCell.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct OperationCell: View {
    
    @ObservedObject var operation: Oprtn

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)){
            VStack {
                Text(operation.name ?? "") //Padding for zstack
                    .fontWeight(.semibold)
                    .font(.body)
                    .padding(10)
                    .foregroundColor(Color(.clear))
                
                    VStack(spacing: 5){
                        if operation.status == OperationStatus.scheduled.rawValue || operation.status == OperationStatus.completed.rawValue {
                            if let startEndString = getStartEndLabel() {
                                CellDetailText(label: startEndString, value: "")
                            }
                            OperationProgressBar(operation: operation)
                        } else {
                            CellDetailText(label: "Stav:", value: OperationStatus(rawValue: operation.status)?.getLabel() ?? "Neznámý")
                        }
                        CellDetailText(label: "Zdroj:", value: ResourceVM.shared.getResName(resID: operation.machineID) ?? "Neznámý")
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 5)
            }
            .background(Color("Background"))
            .cornerRadius(10)

            Text(operation.name ?? "Name???")
                .fontWeight(.semibold)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .padding(.horizontal,5)
                .foregroundColor(Color("Typography"))
                .background(Color("ContentBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow"), radius: 2, x: 0, y: 1)
        }
        .background(Color("ContentBackground")
                        .cornerRadius(10)
                        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
        )
        .padding(.horizontal, 10)

    }
    
    private func getStartEndLabel() -> String?{
        //Time label start:end
        if let start = OperationVM.getOperationStart(oper: operation), let end = OperationVM.getOperationEnd(oper: operation){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM HH:mm"
            return "\(dateFormatter.string(from: start)) - \(dateFormatter.string(from: end))"
        }
        return nil
    }
}



struct OperationCell_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext

    static var previews: some View {
        let operation = Oprtn(context: context)
        operation.name = "Operation name"

        return VStack{
            Spacer()
            OperationCell(operation: operation)
            Spacer()
        }
        .background(Color("Background").ignoresSafeArea())
    }
}

