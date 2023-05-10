//
//
// OperationModel.swift
// PlannerLoop
// Data structures for managing Operations
// Created by Tomáš Tomala
//
	

import Foundation
import SwiftUI
import CoreData



/// Structure for holding operation form values
struct OperationInfo {
    var name: String = ""
    var priorityValue: String = "0"
    var priority: String {
        get {
            return priorityValue
        }
        set {
            if Int(newValue) ?? 0 > 10 {
                priorityValue = "10"
            } else if Int(newValue) ?? 0 < 0 {
                priorityValue = "0"
            } else {
                priorityValue = newValue
            }
        }
    }
    
    var iterations: String = "0"
    var iterDurationMinutes: String = "0"
    var iterDurationSeconds: String = "0"
    var iterDuration : Int32 {
        get { return (Int32(iterDurationSeconds) ?? 0) + (Int32(iterDurationMinutes) ?? 0) * 60 }
        set(newTime) {
            iterDurationSeconds = String(newTime % 60)
            iterDurationMinutes = String(newTime / 60)
        }
    }
    var instTimeMinutes: String = "0"
    var instTimeSeconds: String = "0"
    var instTime : Int32 {
        get { return (Int32(instTimeSeconds) ?? 0) + (Int32(instTimeMinutes) ?? 0) * 60 }
        set(newTime) {
            instTimeSeconds = String(newTime % 60)
            instTimeMinutes = String(newTime / 60)
        }
    }
    var deadline: Date = Date()
    var resource: Resource? = nil
}

/// Enumeration describing operation state
enum OperationStatus: Int16 {
    case unknown = -1
    case toBeScheduled = 0
    case scheduling = 1
    case scheduled = 4
    case failed = 6
    case completed = 8
    
    /// Function for the label of the operation status
    /// - Returns: string with operation status label
    func getLabel() -> String {
        switch self {
            case .unknown:
                return "Neznámý"
            case .toBeScheduled:
                return "K rozvrhnutí"
            case .scheduling:
                return "Rozvrhováno"
            case .scheduled:
                return "Rozvrhnuto"
            case .failed:
                return "Chyba!"
            case .completed:
                return "Dokončeno"
        }
    }
}

/// Enumeration with values for categories of tabview
enum ListCategory: String {
    case machines = "Stroje"
    case employees = "Zaměstnanci"
    case completed = "Ukončené"
    case toConfirm = "K potvrzení"
    case ongoing = "Probíhající"
    case scheduling = "Rozvrhované"

    /// Function to get sorting keys of selected category
    /// - Returns: array with sorting keys
    func getSortKeys() -> [ListSortingKey] {
        switch self {
            case .machines:
                return [.name]
            case .employees:
                return [.name]
            case .completed:
                return [.name, .start, .end]
            case .toConfirm:
                return [.name, .start, .end]
            case .ongoing:
                return [.name, .start, .end]
            case .scheduling:
                return [.name]
        }
    }
}

/// Enumeration with sorting keys of category
enum ListSortingKey: String {
    case name
    case start
    case end
    case index
    case machineID
    case confirmedStages

    /// Function to get label of sorting key
    /// - Returns: string with label of sorting key
    func getLabel() -> String {
        switch self {
            case .name:
                return "Název"
            case .start:
                return "Začátek"
            case .end:
                return "Konec"
            case .index:
                return "Pořadí"
            case .machineID:
                return "Zdroj"
            case .confirmedStages:
                return "Potvrzené iterace"
        }
    }

}
