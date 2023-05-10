//
//
// TimeNeedle.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct TimeNeedle: View {
    @EnvironmentObject var components: ComponentsVM
    let height: CGFloat

    //Needle in schedule
    var body: some View {
        VStack(spacing: -2){
            Circle()
                .stroke(Color("Accent"),lineWidth: 4)
                .frame(width: 15, height: 15)
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 5, height: max(height-45,0))
        }
        .foregroundColor(Color("Accent"))
        .offset(x: calculateOffset(), y: 30+components.scheduleScrollOffset)
    }
    
    
    private func calculateOffset() -> CGFloat{
        //Offset from the start of the schedule
        if Calendar.areTheSameDay(first: components.datePicked, second: Date()){
            //If operation starts selected day, calculate offset
            let hour = Double(Calendar.current.component(.hour, from: Date()))
            let minutes = Double(Calendar.current.component(.minute, from: Date()))
            return CGFloat(Double(components.scheduleWidth)*hour+1.55*minutes)
        }
        return 0
    }
}

struct TimeNeedle_Previews: PreviewProvider {
    static var previews: some View {
        TimeNeedle(height: 300)
    }
}
