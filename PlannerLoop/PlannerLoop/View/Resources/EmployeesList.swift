//
//
// EmployeeList.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct EmployeesList: View {
    //List of employees
    @Binding var selectedCategory: ListCategory
    @Binding var sortKey: ListSortingKey
    var body: some View {
        DynamicRequest(sortKey: sortKey.rawValue,ascending: true, emptyListString: "Zaměstnanci nenalezeni", grid: true){ (object: Employee) in
            NavigationLink(
                destination: ResourceSchedule(res: object),
                label: {
                    ResourceCell(resource: object)
                }
            )
        }
    }
}

struct EmployeeList_Previews: PreviewProvider {
    static var previews: some View {
        EmployeesList(selectedCategory: .constant(.employees), sortKey: .constant(.name))

    }
}
