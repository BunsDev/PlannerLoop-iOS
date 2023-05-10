//
//  TasksVM.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala
//

import Foundation
import SwiftUI

class TasksVM: ObservableObject{
    @Published var selectedDay: Date = Date()
    @Published var currentMonth: [Date] = []
    
    @Published var showDetail: Bool = false
    var selectedTask: Task?
    
    init() {
        fetchCurrentMonth()
    }
    
    //__________________________________________________________________________________
    //Get days of current month
    func fetchCurrentMonth(){
        let today = Date()
        let calendar = Calendar.current
        let month = calendar.dateInterval(of: .month, for: today)
        
        guard let firstDay = month?.start else {
            return
        }
        
        guard let lastDay = month?.end else {
            return
        }
        let daysCount = calendar.numberOfDaysBetween(from: firstDay, to: lastDay)
    
        (0...daysCount-1).forEach { day in
            if let dayInMonth = calendar.date(byAdding: .day, value: day, to: firstDay){
                currentMonth.append(dayInMonth)
            }
        }
    }
    
    func hideTaskDetail(){
        withAnimation(.easeInOut){
            showDetail = false
            selectedTask = nil
        }
    }
    
    func showTaskDetail(task: Task){
        withAnimation(.easeInOut){
            showDetail = true
            selectedTask = task
        }
    }
    
}


