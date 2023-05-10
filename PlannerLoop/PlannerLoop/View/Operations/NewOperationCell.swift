//
//
// NewOperationCell.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

//To be schedule List cell
struct NewOperationCell: View {
    @ObservedObject var operation: Oprtn
    @Environment(\.managedObjectContext) var moc

    let resName: String = ""
    var body: some View {
        HStack(spacing: 0){
            HStack {
                VStack(alignment: .leading, spacing: 0){
                    Text("\(operation.name ?? "Nepojmenováno")"  )
                        .font(.body)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .padding(.horizontal,5)
                        .foregroundColor(Color("Typography"))
                        .background(Color("Background"))
                        .cornerRadius(5)
                    CellDetailText(label: "Zdroj:", value: ResourceVM.shared.getResName(resID: operation.machineID) ?? "Neznámý")
                    CellDetailText(label: "Priorita:", value: String(operation.priority))
                    CellDetailText(label: "Příprava:", value: "\(OperationVM.shared.getDurationLabel(operation.instTime))")
                    CellDetailText(label: "Iterace:", value: "\(operation.iterations) x \(OperationVM.shared.getDurationLabel(operation.iterDuration))")
                    CellDetailText(label: "Deadline:", value: OperationVM.shared.getDateLabel(date: operation.deadline ?? Date()))
                    IndexButtons(operation: operation)
                }
                .padding(5)
            }
            .background(Color("ContentBackground").cornerRadius(10)
                .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
            )
        }
        .padding(.horizontal, 10)
    }
}



struct NewOperationCell_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext

    static var previews: some View {
        let operation = Oprtn(context: context)
        operation.name = "Machine name"
        return VStack{
            Spacer()
            NewOperationCell(operation: operation)
            Spacer()
        }
        .background(Color("Background").ignoresSafeArea())
    }
}


