//
//
// EditResourceDestination.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct EditResourceDestination: View {
    @ObservedObject var res: Resource
    //Show correct edit form
    @ViewBuilder
    var body: some View {
        if let mach = res as? Machine {
            // obj is a Machine
            AddOrEditMachine(machine: mach)
        } else {
            // obj is a Employee
            AddOrEditEmployee(employee: res as? Employee)
        }
    }
}

