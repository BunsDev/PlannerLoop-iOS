//
//
// SQLTable.swift
// PlannerLoop
// Data structures for SQLite Database manager
// Created by Tomáš Tomala
//
	

import Foundation

/// Table entry of operation
struct AJobs {
    let jobId: NSString
    let deadline: NSString
    let priority: Int32
    let instTime: Int32
    let duration: Int32
    let iterations: Int32
    let machineID: NSString
}

/// Table entry of resource
struct ResCalendar {
    let resid: NSString
    let day: NSString
    let start: NSString
    let end: NSString
}

/// Table entry of option
struct Opts {
    let name: NSString
    let value: NSString
}

/// Table entry of operation
struct ScheduleEvent {
    let jobId: NSString
    let resId: NSString
    let blkCode: NSString
    let start: NSString
    let end: NSString
    let iterations: Int32
}

/// Protocol for tables to implement statements
protocol SQLTable {
    //Create empty table
    static var createTableStatement: String { get }
    //Get all entries
    static var selectStatement: String { get }
    //Create new entry
    static var insertStatement: String { get }

}

//Table for operations
extension AJobs: SQLTable {
    static var createTableStatement: String {
        return "CREATE TABLE AJobs(jobId TEXT PRIMARY KEY NOT NULL, deadline TEXT NOT NULL, priority INT NOT NULL, instTime INT NOT NULL, duration INT NOT NULL, iterations INT NOT NULL, machineId TEXT NOT NULL, extResId INT, techId TEXT);"
    }
    
    static var selectStatement: String {
        return "SELECT jobId, deadline, priority, instTime, iterations, duration, machineId FROM AJobs;"
    }
    
    static var insertStatement: String {
        return "INSERT INTO AJobs (jobId, deadline, priority, instTime, iterations, duration, machineId) VALUES (?, ?, ?, ?, ?, ?, ?);"
    }
}

//Table for resources
extension ResCalendar: SQLTable {
    static var createTableStatement: String {
        return "CREATE TABLE ResCalendar( resId TEXT NOT NULL, day TEXT NOT NULL, start TEXT NOT NULL, end TEXT NOT NULL);"
    }
    
    static var selectStatement: String {
        return "SELECT * FROM ResCalendar WHERE resId = ?;"
    }
    
    static var insertStatement: String {
        return "INSERT INTO ResCalendar (resId, day, start, end) VALUES (?, ?, ?, ?);"
    }
}

//Table for options
extension Opts: SQLTable {
    static var createTableStatement: String {
        return "CREATE TABLE Opts(name TEXT, value TEXT);"
    }
    
    static var selectStatement: String {
        return ""
    }
    
    static var insertStatement: String {
        return "INSERT INTO Opts (name, value) VALUES (?, ?);"
    }
}

//Table for scheduled events of operation
extension ScheduleEvent: SQLTable {
    static var createTableStatement: String {
        return "CREATE TABLE Schedule(jobId TEXT, resId TEXT, blkCode TEXT, start TEXT, end TEXT, iterations INT);"
    }
    
    static var selectStatement: String {
        return "SELECT * FROM Schedule WHERE jobId = ?;"
    }
    
    static var insertStatement: String {
        return "INSERT INTO Schedule (jobId, resId, blkCode, start, end, iterations) VALUES (?, ?, ?, ?, ?, ?);"
    }
}


/// Enumeration with possible errors of database engine
enum SQLiteError: Error {
    case InvalidData(message: String)
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
    case Scheduled
    case OperationError
    case ResourceError

    func convertToErrDesc() -> ErrorDescription {
        switch self {
        case .InvalidData: return .noResourceID
        case .OpenDatabase: return .openingDatabase
        case .Bind: return .databaseInsert
        case .OperationError: return .noOperationInfo
        case .ResourceError: return .noResourceInfo
        case .Scheduled: return .invalidScheduled
        default: return .invalidDBFile
        }
    }
}
 

