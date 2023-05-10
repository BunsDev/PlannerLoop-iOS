//
//
// DisponibilityPicker.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
    

import SwiftUI

struct DisponibilityPicker: View {
    @Binding var info: DisponibilityInfo
    //Picker for ResCalendar
    var body: some View {
        VStack(spacing: 10){
             VStack {
                HStack {
                    DisponibilityDayButton(text: "Každý den", type: .all, activated: $info.selectedDay)
                    DisponibilityDayButton(text: "Pracovní dny", type: .workdays, activated: $info.selectedDay)
                }
                DisponibilityDayButton(text: "Jednotlivé dny", type: .individual, activated: $info.selectedDay)
            }
            if info.selectedDay == .individual {
                VStack(spacing: 5){
                    Group {
                        DisponibilityDayTime(text: "Po", activated: $info.mondayActivated, from: $info.mondayStart, to: $info.mondayEnd)
                        Divider()
                        DisponibilityDayTime(text: "Út", activated: $info.tuesdayActivated, from: $info.tuesdayStart, to: $info.tuesdayEnd)
                        Divider()
                        DisponibilityDayTime(text: "St", activated: $info.wednesdayActivated, from: $info.wednesdayStart, to: $info.wednesdayEnd)
                        Divider()
                        DisponibilityDayTime(text: "Čt", activated: $info.thursdayActivated, from: $info.thursdayStart, to: $info.thursdayEnd)
                    }
                    Group {
                        Divider()
                        DisponibilityDayTime(text: "Pá", activated: $info.fridayActivated, from: $info.fridayStart, to: $info.fridayEnd)
                        Divider()
                        DisponibilityDayTime(text: "So", activated: $info.saturdayActivated, from: $info.saturdayStart, to: $info.saturdayEnd)
                        Divider()
                        DisponibilityDayTime(text: "Ne", activated: $info.sundayActivated, from: $info.sundayStart, to: $info.sundayEnd)
                    }
                }
                .padding(5)
                .background(Color("Background").cornerRadius(10))
            } else {
                VStack{
                    HStack{
                        Text("Od")
                            .fontWeight(.regular)
                            .font(.footnote)
                            .foregroundColor(Color("Typography"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        DatePicker("", selection: $info.mondayStart, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .accentColor(Color("AccentHigh"))

                    }
                    Divider()
                    HStack{
                        Text("Do")
                            .fontWeight(.regular)
                            .font(.footnote)
                            .foregroundColor(Color("Typography"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        DatePicker("", selection: $info.mondayEnd, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .accentColor(Color("AccentHigh"))
                    }
                }
                .padding(10)
                .background(Color("Background"))
                .cornerRadius(10)
            }
        }
    }
}

