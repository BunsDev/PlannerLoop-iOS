//
//
// ComponentsVM.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import Foundation
import SwiftUI

class ComponentsVM: ObservableObject {
        
    @Published var operationDetail: Oprtn?
    ///Selected categories
    @Published var operationsSelectedCategory: ListCategory = .ongoing
    @Published var resourcesSelectedCategory: ListCategory = .machines

    @Published var tabBarShown: Bool = true
    @Published var showSettingsSheet: Bool = false

    ///Days of selected month
    @Published var selectedMonthDays: [Date] = []

    ///Schedule day picker
    @Published var dayPicked: Int
    @Published var monthPicked: Int
    @Published var yearPicked: Int
    
    ///Base width of hour column in schedule
    var scheduleWidth: CGFloat {
        get {
            return scheduleWidthValue
        }
        set {
            scheduleWidthValue = min(maxScale, max(minScale,newValue))
        }
    }
    
    ///Schedule confing
    @Published var scheduleWidthValue: CGFloat = 100
    let maxScale: CGFloat = 300
    let minScale: CGFloat = 100
    @Published var scheduleScrollOffset = CGFloat.zero


    ///Computed property to manage picked date in schedule
    var datePicked: Date {
        get {
            return DateComponents(calendar: Calendar.current, year: yearPicked, month: monthPicked, day: dayPicked).date ?? Date()
        }
        set {
            dayPicked =  Calendar.current.component(.day, from: newValue)
            monthPicked =  Calendar.current.component(.month, from: newValue)
            yearPicked =  Calendar.current.component(.year, from: newValue)
            fetchCurrentMonth()

        }
    }
    
    ///Initialization of componentsVM. Set pickedDate
    init() {
        let today = Date()
        dayPicked =  Calendar.current.component(.day, from: today)
        monthPicked =  Calendar.current.component(.month, from: today)
        yearPicked =  Calendar.current.component(.year, from: today)
        fetchCurrentMonth()
    }
    

    /// Show tab bar if it is hidden
    func showTabBar(){
        if tabBarShown == false {
            withAnimation {
                tabBarShown = true
            }
        }
    }
    
    ///Hide tab bar if it is visible
    func hideTabBar(){
        if tabBarShown == true {
            tabBarShown = false
        }
    }
   

    /// Change month of selected date
    /// - Parameter month: selected month
    func changeToMonth(month: Int){
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: yearPicked, month: month)
        let date = calendar.date(from: dateComponents)!
        //Get number of days in month the date is changing to
        let daysCount = calendar.range(of: .day, in: .month, for: date)!.count
        //If next month doesnt have the current day number, select last day of the next month
        if dayPicked > daysCount {
            dayPicked = daysCount
        }
        self.monthPicked = month
        fetchCurrentMonth()
    }
    
    ///Get days for selected month
    func fetchCurrentMonth(){
        selectedMonthDays = []
        let date = datePicked
        let calendar = Calendar.current
        let month = calendar.dateInterval(of: .month, for: date)
        
        guard let firstDay = month?.start else {
            return
        }
        
        guard let lastDay = month?.end else {
            return
        }
        let daysCount = calendar.numberOfDaysBetween(from: firstDay, to: lastDay)
    
        (0...daysCount-1).forEach { day in
            if let dayInMonth = calendar.date(byAdding: .day, value: day, to: firstDay){
                self.selectedMonthDays.append(dayInMonth)
            }
        }
    }
}






