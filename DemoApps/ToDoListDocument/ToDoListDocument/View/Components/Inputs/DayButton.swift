//
//  DayButton.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct DayButton: View {
    //Single day button in day picker
    @Binding var selectedDate: Date
    var actualDay: Date
    let calendar = Calendar.current
    var body: some View {
        VStack {
            Text(calendar.dayOfTheWeek(date: actualDay))
                .foregroundColor(
                    calendar.areTheSameDay(first: selectedDate, second: actualDay) ? Color(.black) : Color("TypograghyMedium")
                )
                .font(.system(size: 14, weight: .medium))
                .frame(width: 35)
            Text(calendar.dayOfTheMonth(date: actualDay))
                .foregroundColor(
                    calendar.areTheSameDay(first: selectedDate, second: actualDay) ? Color(.black) : Color("Typograghy")
                )
                .font(.system(size: 16, weight: .semibold))
        }
        .padding(10)
        .background(
            calendar.areTheSameDay(first: selectedDate, second: actualDay) ? Color("Accent") : Color("ContentBackground")
        )
        .cornerRadius(10)
        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 2)

    }
}

struct DayButton_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
