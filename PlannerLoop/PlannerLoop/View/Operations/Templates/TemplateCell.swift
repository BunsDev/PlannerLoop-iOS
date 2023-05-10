//
//
// TemplateCell.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

///Template cell in list of templates
struct TemplateCell: View {
    @ObservedObject var template: Template
    @State var activated: Bool = false
    @State var showButtons: Bool = true
    @Environment(\.managedObjectContext) var moc

    var body: some View {
        VStack(spacing: 0){
            HStack {
                //Template basic information
                Text(template.name ?? "")
                    .fontWeight(.semibold)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Image(systemName: activated ? "plus" : "info")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .rotationEffect(.init(degrees: activated ? 45 : 0))
                    .clipped()
                    .padding(10)
                    .background(Color("ContentBackground").cornerRadius(10))
                    .onTapGesture {
                        withAnimation{
                            activated.toggle()
                        }
                    }
            }
            .padding(10)
            .foregroundColor(Color("Typography"))
            if(activated){
                VStack{
                    Divider()
                    HStack{
                        VStack{
                            //Template information
                            CellDetailText(label: "Priorita:", value: String(template.priority))
                            CellDetailText(label: "Iterace:", value: "\(template.iterations) x \(OperationVM.shared.getDurationLabel(template.iterDuration))")
                            CellDetailText(label: "Doba přípravy:", value: "\(OperationVM.shared.getDurationLabel(template.instTime))")
                            if let machine = ResourceVM.getMachine(machineID: template.machineID ?? "") {
                                CellDetailText(label: "Stroj:", value: String(machine.name ?? ""))
                            } else if let employee = ResourceVM.getEmployee(employeeID: template.machineID ?? "") {
                                CellDetailText(label: "Zaměstnanec:", value: "\(employee.name ?? "") \(employee.surname ?? "Unknown")")
                            }
                        }
                        //Template edit and delete buttons
                        if showButtons {
                            VStack{
                                Button(action: {
                                    moc.delete(template)
                                    try? moc.save()
                                }, label: { ButtonImageLabel(image: "trash", bgColor: "Danger", padding: 10, size: 20) })
                                Spacer()
                                NavigationLink(
                                    destination: AddOrEditTemplate(template: template),
                                    label: { ButtonImageLabel(image: "slider.horizontal.3", bgColor: "Accent", padding: 10, size: 20) }
                                )
                            }
                        }
                    }
                }
                .padding(.bottom, 5)
                .padding(.horizontal, 10)
            }
        }
        .background(
            Color("Background")
                .cornerRadius(10)
                .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
        )
        .padding(.horizontal, 5)
    }
}

struct TemplateCell_Previews: PreviewProvider {
    
    static let context = PersistenceController.shared.container.viewContext

    static var previews: some View {
        let template = Template(context: context)
        template.name = "Template name"

        return VStack{
            Spacer()
            TemplateCell(template: template)
            Spacer()
        }
        .background(Color("Background").ignoresSafeArea())
    }
}
