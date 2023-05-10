//
//
// ProgressBar.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct MaterialProgressBar: View {
    var value: Int32
    var maxValue: Int32
    var progress: Float {
        if value==0 {return 0.0}
        return Float(value)/Float(maxValue)
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                //Background
                RoundedRectangle(cornerRadius: 15).frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(progress == 0.0 ? Color("Danger") : Color("Disabled"))
                //Bar
                RoundedRectangle(cornerRadius: 15).frame(width: min(CGFloat(self.progress)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(
                        progress > 0.3 ? Color("Accent") : (progress > 0.1 ? Color("Warning") : Color("Danger"))
                    )
                    .animation(.linear)
            }
        }

    }
}
