//
//
// MachinePicker.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct MachinePicker: View {

    @Binding var picked: Resource?
    
    var body: some View {
        //List of machine objects
        DynamicRequest(sortKey: ListSortingKey.name.rawValue, ascending: true, emptyListString: "Stroje nenalezeny", grid: false){ (object: Machine) in
            ResourceCell(resource: object)
                .onTapGesture { withAnimation { picked = object } }
        }
    }
}

struct MachinePicker_Previews: PreviewProvider {
    static var previews: some View {
        MachinePicker(picked: .constant(nil))
    }
}



