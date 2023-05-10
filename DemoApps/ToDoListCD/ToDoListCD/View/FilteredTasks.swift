//
//  FilteredTasks.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala
//https://www.hackingwithswift.com/books/ios-swiftui/dynamically-filtering-fetchrequest-with-swiftui

import SwiftUI
import CoreData

struct FilteredTasks<T: NSManagedObject, Content: View>: View {
    //Prepare fetch request for generic type T
    @FetchRequest var fetchRequest: FetchedResults<T>
    //Content to show with fetched objects
    let content: (T) -> Content
    
    var body: some View {
        Group {
            if fetchRequest.isEmpty {
                //No objects returned
                Text("No Tasks For This Day")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(10)
                    .foregroundColor(Color("TypograghyMedium"))
            } else {
                ForEach(fetchRequest, id: \.self) { object in
                    self.content(object)
                }
            }
        }
    }
    
    
    init(filterKey: String, date: Date, @ViewBuilder content: @escaping (T) -> Content) {
        //Date filtering tasks, creating predicate
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: date)
        if let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom) {
            let filterKey = "due"
            let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray:[dateFrom,dateTo])
            //Fetch tasks from begging to the end of the selected day
            _fetchRequest = FetchRequest<T>(sortDescriptors: [NSSortDescriptor(keyPath: \Task.due, ascending: true)], predicate: predicate)
        } else {
            //Error while deriving next date from selected one, fetch all tasks
            _fetchRequest = FetchRequest<T>(sortDescriptors: [NSSortDescriptor(keyPath: \Task.due, ascending: true)], predicate: nil)
        }
        self.content = content
    }
    
}


