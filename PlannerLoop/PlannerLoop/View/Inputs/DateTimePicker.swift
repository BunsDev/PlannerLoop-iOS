//
//
// DateTimePicker.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct DateTimePicker: View {
    let title: String
    @Binding var dueDate: Date
    var body: some View {
        //Form input with datepicker
        LabeledContainer(label: title) {
            HStack(spacing: 5){
                TimeLabel(date: $dueDate, hours: false)
                TimeLabel(date: $dueDate, hours: true)
                Spacer()
                Button(action: {
                    dueDate = Calendar.current.date(byAdding: .day, value: 7, to: dueDate) ?? dueDate
                }, label: {
                    Text("+Týd")
                        .padding(10)
                        .font(.footnote)
                        .background(Color("Background").cornerRadius(10).shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3))
                        .foregroundColor(Color("Typography"))
                })
                
                Button(action: {
                    dueDate = Calendar.current.date(byAdding: .day, value: 1, to: dueDate) ?? dueDate
                }, label: {
                    Text("+Den")
                        .padding(10)
                        .font(.footnote)
                        .background(Color("Background").cornerRadius(10).shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3))
                        .foregroundColor(Color("Typography"))
                })

            }
            .font(.body)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}




struct TimeLabel: View {
    @Binding var date: Date
    let hours: Bool
    var body: some View {
        Text( hours ? Calendar.getHoursString(date: date) : Calendar.getDayString(date: date))
            .fontWeight(.medium)
            .padding(10)
            .background(Color("Accent"))
            .cornerRadius(10)
            .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
            .overlay(
                DatePicker("", selection: $date, displayedComponents:  hours ? .hourAndMinute : .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .accentColor(Color("AccentHigh"))
                    .labelsHidden()
                    .opacity(0.015)
            )
    }
}
