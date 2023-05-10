//
//  ToDoListCDApp.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala
//

import SwiftUI

@main
struct ToDoListCDApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}

extension Calendar {
    func numberOfDaysBetween(from: Date, to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day!
    }
    
    func dayOfTheWeek(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
    
    func dayOfTheMonth(date: Date) -> String{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        if let day = components.day {
            return String(day)
        }
        return ""
    }
    
    func areTheSameDay(first: Date,second: Date) -> Bool{
        return Calendar.current.isDate(first, equalTo: second, toGranularity: .day)
        
    }
}
