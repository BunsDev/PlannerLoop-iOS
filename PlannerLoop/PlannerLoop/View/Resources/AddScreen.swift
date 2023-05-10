//
//
// AddScreen.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct AddScreen: View {
    @Binding var selectedCategory: ListCategory
    var body: some View {
        //Pick correct form
        if selectedCategory == ListCategory.employees{
            AddOrEditEmployee()
        } else {
            AddOrEditMachine()
        }
    }
}
