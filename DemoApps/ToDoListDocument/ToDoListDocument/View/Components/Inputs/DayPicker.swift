//
//  DayPicker.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct DayPicker: View {
    //Horizontal scrollView with current month days
    @Binding var days: [Date]
    @Binding var selectedDate: Date
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(days, id: \.self){ day in
                        Button(action: {
                            withAnimation{
                                selectedDate = day
                            }
                        }, label: {
                            DayButton(selectedDate: $selectedDate,actualDay: day)
                        })
                    }
                    .padding(.bottom, 5)
                }
                .onAppear {
                    if let dayToScroll = Int(Calendar.current.dayOfTheMonth(date: selectedDate)) {
                        scrollView.scrollTo(days[dayToScroll-1], anchor: .center)
                    }
                }
            }
            .padding(.horizontal, 5)
            .background(Color("Background"))

        }
    }
    
}

struct DayPicker_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}


