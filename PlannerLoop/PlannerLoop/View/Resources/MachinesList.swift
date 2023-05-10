//
//
// MachinesList.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct MachinesList: View {
    //List of machines
    @Binding var selectedCategory: ListCategory
    @Binding var sortKey: ListSortingKey
    var body: some View {
        DynamicRequest(sortKey: sortKey.rawValue,ascending: true, emptyListString: "Stroje nenalezeny", grid: true){ (object: Machine) in
            NavigationLink(
                destination: ResourceSchedule(res: object),
                label: {
                    ResourceCell(resource: object)
                }
            )
        }
    }
}

struct MachinesList_Previews: PreviewProvider {
    static var previews: some View {
        MachinesList(selectedCategory: .constant(.machines), sortKey: .constant(.name))
    }
}
