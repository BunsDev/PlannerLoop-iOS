//
//
// FormPicker.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

//Show correct form based on device
struct FormPicker: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        if horizontalSizeClass != .regular {
            //Mobile Form
            Text("Todo")
//            DetailsTab(info: $info)
//            ResourceTab(info: $info)
        } else  {
            //iPad Form
            Templates()
        }
    }
}

struct FormPicker_Previews: PreviewProvider {
    static var previews: some View {
        FormPicker()
    }
}
