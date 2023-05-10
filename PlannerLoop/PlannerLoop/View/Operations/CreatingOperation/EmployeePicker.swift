//
//
// EmployeePicker.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct EmployeePicker: View {
    @Binding var picked: Resource?
    
    var body: some View {
        //List of employee objects
        DynamicRequest(sortKey: ListSortingKey.name.rawValue, ascending: true, emptyListString: "Zaměstnanci nenalezeni", grid: false){ (object: Employee) in
            ResourceCell(resource: object)
            .onTapGesture {
                withAnimation {
                    picked = object
                }
            }
        }
    }
}

struct EmployeePicker_Previews: PreviewProvider {
    static var previews: some View {
        EmployeePicker(picked: .constant(nil))
    }
}


