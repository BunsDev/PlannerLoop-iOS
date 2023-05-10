//
//
// ResourceModel.swift
// PlannerLoop
// Data structures for managing Employee and Machine class
// Created by Tomáš Tomala
//
    

import SwiftUI
import Foundation


/// Enumeration of values describing selected type of disponibility
enum DisponibilityDay : String, Codable {
    case all = "ALL"
    case workdays = "WD"
    case individual = ""
    case monday = "MO"
    case tuesday = "TU"
    case wednesday = "WE"
    case thursday = "TH"
    case friday = "FR"
    case saturday = "SA"
    case sunday = "SU"
    
    /// Function to return name of the type of disponibility type
    /// - Returns: string with the name of the type of disponibility type
    func getLabel() -> String {
        switch self {
        case .all:
            return "Všechny dny"
        case .workdays:
            return "Pracovní dny"
        case .individual:
            return "Jednotlivé dny"
        case .monday:
            return "Pondělí"
        case .tuesday:
            return "Úterý"
        case .wednesday:
            return "Středa"
        case .thursday:
            return "Čtvrtek"
        case .friday:
            return "Pátek"
        case .saturday:
            return "Sobota"
        case .sunday:
            return "Neděle"
        }
    }
}

/// Struct with values for every single day of resource disponibility
struct DisponibilityInfo : Codable {
    var selectedDay: DisponibilityDay = .all
    
    var mondayStart: Date = Calendar.current.startOfDay(for: Date())
    var mondayEnd: Date = Calendar.getDayEnd()
    var mondayActivated: Bool = true

    var tuesdayStart: Date = Calendar.current.startOfDay(for: Date())
    var tuesdayEnd: Date = Calendar.getDayEnd()
    var tuesdayActivated: Bool = true

    var wednesdayStart: Date = Calendar.current.startOfDay(for: Date())
    var wednesdayEnd: Date = Calendar.getDayEnd()
    var wednesdayActivated: Bool = true

    var thursdayStart: Date = Calendar.current.startOfDay(for: Date())
    var thursdayEnd: Date = Calendar.getDayEnd()
    var thursdayActivated: Bool = true

    var fridayStart: Date = Calendar.current.startOfDay(for: Date())
    var fridayEnd: Date = Calendar.getDayEnd()
    var fridayActivated: Bool = true

    var saturdayStart: Date = Calendar.current.startOfDay(for: Date())
    var saturdayEnd: Date = Calendar.getDayEnd()
    var saturdayActivated: Bool = true

    var sundayStart: Date = Calendar.current.startOfDay(for: Date())
    var sundayEnd: Date = Calendar.getDayEnd()
    var sundayActivated: Bool = true
}


/// Struct with resource information
struct ResourceInfo {
    var name: String = ""
    var lastname: String = ""
    var disponibility: DisponibilityInfo = DisponibilityInfo()
}


/// Struct with day labels
enum DayLabel : Int {
    case none = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
    
    /// Function to return name of a day in Czech
    /// - Returns: string with the name of the day in Czech
    func getLabel() -> String {
        switch self {
            case .none: return ""
            case .monday: return "Po"
            case .tuesday: return "Út"
            case .wednesday: return "St"
            case .thursday: return "Čt"
            case .friday: return "Pá"
            case .saturday: return "So"
            case .sunday: return "Ne"
        }
    }
}

/// Struct with month labels
enum MonthLabel : Int {
    case january = 1
    case february = 2
    case march = 3
    case april = 4
    case may = 5
    case june = 6
    case july = 7
    case august = 8
    case september = 9
    case october = 10
    case november = 11
    case december = 12
    
    /// Function to return name of a month in Czech
    /// - Returns: string with the name of the month in Czech
    func getLabel() -> String {
        switch self {
            case .january: return "Leden"
            case .february: return "Únor"
            case .march: return "Březen"
            case .april: return "Duben"
            case .may: return "Květen"
            case .june: return "Červen"
            case .july: return "Červenec"
            case .august: return "Srpen"
            case .september: return "Září"
            case .october: return "Říjen"
            case .november: return "Listopad"
            case .december: return "Prosinec"
        }
    }
}







