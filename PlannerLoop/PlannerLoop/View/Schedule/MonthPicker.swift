//
//
// MonthPicker.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct MonthPicker: View {
    @Binding var selectedDate: Date
    @EnvironmentObject var components: ComponentsVM
    @State var months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] //Array with months for autoscroll of scrollview

    //Picker with list of months
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(months, id: \.self){ month in
                        Button(action: {
                            components.changeToMonth(month: month)
                        }, label: {
                            Text("\(MonthLabel.init(rawValue: month)?.getLabel() ?? "")")
                                .fontWeight(.bold)
                                .font(.body)
                                .foregroundColor(
                                    Calendar.areTheSameMonth(date: selectedDate, month: month) ? Color("Accent") : Color("TypographyMedium")
                                )
                        })
                    }
                }
                .padding(.bottom, 5)

            }
            .padding(.horizontal, 5)
        }
    }
}
