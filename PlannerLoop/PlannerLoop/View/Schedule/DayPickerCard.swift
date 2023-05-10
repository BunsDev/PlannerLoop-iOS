//
//
// DayPickerCard.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct DayPickerCard: View {
    @EnvironmentObject var components: ComponentsVM
    @Binding var showFull : Bool 
    var body: some View {
        VStack{
            if showFull {
                MonthPicker(selectedDate: $components.datePicked)
                DayPicker(days: $components.selectedMonthDays, selectedDate: $components.datePicked)
            RoundedRectangle(cornerRadius: 5)
                .frame(maxWidth: .infinity)
                .frame(height: 3)
                .padding(.horizontal, 20)
                .foregroundColor(Color("TypographyLow"))
            }
            HStack(){
                //Button for previous day
                Button(action: {
                    withAnimation{
                        components.datePicked = Calendar.current.date(byAdding: .day, value: -1, to: components.datePicked) ?? components.datePicked
                    }
                }, label: { ButtonImageLabel(image: "chevron.left" , bgColor: "Background", padding: 10, size: 15) })
                Spacer()
                //Current date label with daypicker
                Text(Calendar.getDayString(date: components.datePicked))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Typography"))
                    .overlay(
                        DatePicker("", selection: $components.datePicked, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .accentColor(Color("AccentHigh"))
                            .labelsHidden()
                            .opacity(0.015)
                    )
                    .padding(.leading)
                //Button to hide day picker
                Button(action: { withAnimation{ showFull.toggle() }
                }, label: { ButtonImageLabel(image: showFull ? "chevron.up" : "chevron.down" , bgColor: "Background", padding: 10, size: 15) })
                Spacer()
                //Button for next day
                Button(action: {
                    withAnimation{
                        components.datePicked = Calendar.current.date(byAdding: .day, value: 1, to: components.datePicked) ?? components.datePicked
                    }
                }, label: { ButtonImageLabel(image: "chevron.right", bgColor: "Background", padding: 10, size: 15) })
            }
            .padding(.horizontal, 5)
        }
        .padding(.bottom, 5)
        .padding(.top, showFull ? 10 : 5)
        .background(Color("ContentBackground")
                        .ignoresSafeArea()
                        .cornerRadius(10)
                        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
        )
        .padding(.top, 5)
        .padding(.horizontal, 10)
    }
}

struct DayPickerCard_Previews: PreviewProvider {
    static var previews: some View {
        DayPickerCard(showFull: .constant(true))
            .environmentObject(ComponentsVM())
    }
}

