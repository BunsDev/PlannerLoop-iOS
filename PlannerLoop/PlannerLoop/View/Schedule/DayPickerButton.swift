//
//  DayButton.swift
//  PlannerLoop
//
//  Created by Tomáš Tomala
//
import SwiftUI

struct DayPickerButton: View {
    //Single day button in day picker
    @Binding var selectedDate: Date
    var actualDay: Date
    var body: some View {
        VStack {
            Text(DayLabel(rawValue: dayNumberOfWeek(date: actualDay))?.getLabel() ?? "")
                .foregroundColor(
                    Calendar.areTheSameDay(first: selectedDate, second: actualDay) ? Color(.black) : Color("TypographyMedium")
                )
                .font(.footnote)
                .fontWeight(.medium)
                .frame(width: 35)
            Text(Calendar.dayOfTheMonth(date: actualDay))
                .foregroundColor(
                    Calendar.areTheSameDay(first: selectedDate, second: actualDay) ? Color(.black) : Color("Typography")
                )
                .fontWeight(.semibold)
                .font(.body)
        }
        .padding(10)
        .background(
            Calendar.areTheSameDay(first: selectedDate, second: actualDay) ? Color("Accent") : Color("Background")
        )
        .cornerRadius(10)
        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 2)

    }
    ///Get day in week number
    func dayNumberOfWeek(date: Date) -> Int {
        return Calendar.current.dateComponents([.weekday], from: date).weekday ?? 0
    }
}

struct DayPickerButton_Previews: PreviewProvider {
    static var previews: some View {
        DayPickerButton(selectedDate: .constant(Date()), actualDay:Date())
    }
}
