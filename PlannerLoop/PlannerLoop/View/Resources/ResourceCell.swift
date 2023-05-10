//
//
// ResourceCell.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct ResourceCell: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var resource: Resource
    
    var disponibilityDay: DisponibilityDay
    var disponibilityStart: String
    var disponibilityEnd: String

    init(resource: Resource){
        self._resource = ObservedObject(wrappedValue: resource)
        self.disponibilityDay = DisponibilityDay(rawValue:resource.disponibilityDay ?? DisponibilityDay.all.rawValue) ?? .all
        self.disponibilityStart = Calendar.getHoursString(date: resource.mondayStart ?? Date())
        self.disponibilityEnd = Calendar.getHoursString(date: resource.mondayEnd ?? Date())
    }
    var body: some View {
        //Table cell for machine
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)){
            VStack {
                //Padding for zstack
                Text(ResourceVM.shared.getResName(resID: resource.identifier) ?? "Unknown")
                    .fontWeight(.semibold)
                    .font(.body)
                    .padding(12)
                    .foregroundColor(Color(.clear))
                //Disponibility
                if resource.disponibilityDay == DisponibilityDay.all.rawValue || resource.disponibilityDay == DisponibilityDay.workdays.rawValue   {
                    VStack(spacing: 5){
                        HStack(spacing: 0){
                            //Working hours or next operation
                            Text("Pracovní doba: \(disponibilityDay.getLabel())")
                                .fontWeight(.semibold)
                                .font(.footnote)
                            Text(" \(disponibilityStart)-\(disponibilityEnd)")
                                .fontWeight(.semibold)
                                .font(.footnote)
                        }
                        .foregroundColor(Color("Typography"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 5)
                }
            }
            .background(Color("Background"))
            .cornerRadius(10)
            //Name
            Text(ResourceVM.shared.getResName(resID: resource.identifier) ?? "Unknown")
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
}

struct ResourceCell_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext

    static var previews: some View {
        let machine = Machine(context: context)
        machine.name = "Machine name"

        return VStack{
            Spacer()
            ResourceCell(resource: machine)
            Spacer()
        }
        .background(Color("Background").ignoresSafeArea())
    }
}
