//
//
// DetailsTab.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI


struct DetailsTab: View {
    //Main operation form
    @Binding var info: OperationInfo
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var deadline: Bool = true
    var body: some View {
        //Form with basic details about operation
        VStack {
            TextFieldNeu(label: "Název", text: $info.name)
            PriorityPicker(title: "Priorita", value: $info.priority)
            NumberPicker(title: "Počet iterací", value: $info.iterations)
            //Installation time
            TimePicker(title: "Doba trvání přípravy", seconds: $info.instTimeSeconds, minutes: $info.instTimeMinutes)
            //Iteration duration
            TimePicker(title: "Doba trvání iterace", seconds: $info.iterDurationSeconds, minutes: $info.iterDurationMinutes)
            if deadline {
                DateTimePicker(title: "Deadline", dueDate: $info.deadline)
            }
        }
        .padding(.bottom, 5)
        .padding(.trailing, horizontalSizeClass == .regular ?  5 : 0)
        .padding(.leading, horizontalSizeClass == .regular ?  10 : 0 )
        .hiddenNavigationBarStyle()
    }
}
