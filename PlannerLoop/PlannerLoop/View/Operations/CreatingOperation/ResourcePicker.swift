//
//
// ResourcePicker.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct ResourcePicker: View {
    @State var showDetails: Bool = true
    @Binding var info: OperationInfo
    
    @State var resourceType: ListCategory = .machines
    
    var body: some View {
        //View with resource list to choose from
        LabeledContainer(label: "Výběr výrobního zdroje"){
            if let _ = info.resource {
                PickedResourceCell(picked: $info.resource)
                .animation(.easeIn)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]){
                        Section(header: getHeader()){
                            if resourceType == .machines {
                                MachinePicker(picked: $info.resource)
                            } else {
                                EmployeePicker(picked: $info.resource)
                            }
                        }
                    }
                    .padding(.horizontal, 5)
                }
            }
        }
    }
    private func getHeader() -> some View {
        return Picker(selection: $resourceType, label: Text("")) {
            Text(ListCategory.machines.rawValue).tag(ListCategory.machines)
            Text(ListCategory.employees.rawValue).tag(ListCategory.employees)
        }.pickerStyle(SegmentedPickerStyle())
    }
}


