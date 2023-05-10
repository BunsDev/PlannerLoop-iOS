//
//
// SQLiteDatabase.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//


import Foundation
import SQLite3
import CoreData

class SQLiteDatabase {
    ///Database file with task to submit
    static let dbFilename = "submitTask.db"
    ///Database file with downloaded task
    static let downloadedDBFilename = "downloadTask.db"
    
    private let dbPointer: OpaquePointer?
    private let dbUrl: URL
    
    private init(dbPointer: OpaquePointer?, dbUrl: URL) {
        self.dbPointer = dbPointer
        self.dbUrl = dbUrl
    }
    
    deinit {
        //Close connection on object deinitialization
        sqlite3_close(dbPointer)
    }
    
    
    var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }
    
    
    /// Open database connection
    /// - Parameter dbUrl: On which URL to open connection
    /// - Throws: SQLiteError
    /// - Returns: SQLiteDatabase instance
    static func open(dbUrl: URL) throws -> SQLiteDatabase {
        var db: OpaquePointer?
        
        if sqlite3_open(dbUrl.absoluteString, &db) == SQLITE_OK {
            return SQLiteDatabase(dbPointer: db, dbUrl: dbUrl)
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String(cString: errorPointer)
                throw SQLiteError.OpenDatabase(message: message)
            } else {
                throw SQLiteError.OpenDatabase(message: "No error message provided from sqlite.")
            }
        }
    }
    
    /// Run create table query
    /// - Parameter table: For which table to run the command
    /// - Throws: SQLiteError
    func createTable(table: SQLTable.Type) throws {
        let createTableStatement = try prepareStatement(sql: table.createTableStatement)
        defer {
            sqlite3_finalize(createTableStatement)
        }
        guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
    }
    
    /// Insert operation to Ajobs table
    /// - Parameter operation: Oprtn object to insert into AJobs
    /// - Throws: SQLiteError
    func insertOperation(operation: Oprtn) throws {
                
        guard let jobId = operation.identifier else {
            throw SQLiteError.OperationError
        }
        
        guard let deadline = operation.deadline else {
            throw SQLiteError.OperationError
        }
        
        guard let machId = ResourceVM.shared.getRes(resID: operation.machineID)?.identifier else {
            throw SQLiteError.ResourceError
        }

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let insertSql = AJobs.insertStatement
        let insertStatement = try prepareStatement(sql: insertSql)
        defer {
            sqlite3_finalize(insertStatement)
        }
        guard
            sqlite3_bind_text(insertStatement, 1, (jobId as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 2, (df.string(from: deadline) as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_int(insertStatement, 3, Int32(operation.priority)) == SQLITE_OK  &&
            sqlite3_bind_int(insertStatement, 4, Int32(operation.instTime)) == SQLITE_OK  &&
            sqlite3_bind_int(insertStatement, 5, Int32(operation.iterations)) == SQLITE_OK  &&
            sqlite3_bind_text(insertStatement, 7, (machId as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_int(insertStatement, 6, Int32(operation.iterDuration)) == SQLITE_OK
        else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
    }
    
    
    /// Insert timezone data
    /// - Throws: SQLiteError
    func specifyTimezone(timeZero: Date, specifyTimeZero: Bool) throws {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = specifyTimeZero ? timeZero : Date()
        let insertSql = Opts.insertStatement
        let insertStatement = try prepareStatement(sql: insertSql)
        defer {
            sqlite3_finalize(insertStatement)
        }
        guard
            sqlite3_bind_text(insertStatement, 1, ("timeZero" as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 2, (df.string(from: date) as NSString).utf8String, -1, nil) == SQLITE_OK
        else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        
    }
    
    
    /// For every activated day of disponibilty insert entry
    /// - Parameter operation: For which Oprtn to insert data of resource
    /// - Throws: SQLiteError
    func insertRes(operation: Oprtn) throws {
        
        guard let mach = ResourceVM.shared.getRes(resID: operation.machineID) else {
            throw SQLiteError.ResourceError
        }
        
        guard let machId = mach.identifier else {
            throw SQLiteError.ResourceError
        }
        
        guard let disponibilityType = DisponibilityDay.init(rawValue: mach.disponibilityDay ?? DisponibilityDay.all.rawValue) else {
            throw SQLiteError.ResourceError
        }
        do {
            if disponibilityType == .all || disponibilityType == .workdays {
                try insertResDispo(id: machId, day: disponibilityType.rawValue, start: getDispoTime(mach.mondayStart), end: getDispoTime(mach.mondayEnd))
            } else {
                if mach.mondayActivated {
                    try insertResDispo(id: machId, day: DisponibilityDay.monday.rawValue , start: getDispoTime(mach.mondayStart), end: getDispoTime(mach.mondayEnd))
                }
                if mach.tuesdayActivated {
                    try insertResDispo(id: machId, day: DisponibilityDay.tuesday.rawValue , start: getDispoTime(mach.tuesdayStart), end: getDispoTime(mach.tuesdayEnd))
                }
                if mach.wednesdayActivated {
                    try insertResDispo(id: machId, day: DisponibilityDay.wednesday.rawValue , start: getDispoTime(mach.wednesdayStart), end: getDispoTime(mach.wednesdayEnd))
                }
                if mach.thursdayActivated {
                    try insertResDispo(id: machId, day: DisponibilityDay.thursday.rawValue , start: getDispoTime(mach.thursdayStart), end: getDispoTime(mach.thursdayEnd))
                }
                if mach.fridayActivated {
                    try insertResDispo(id: machId, day: DisponibilityDay.friday.rawValue , start: getDispoTime(mach.fridayStart), end: getDispoTime(mach.fridayEnd))
                }
                if mach.saturdayActivated {
                    try insertResDispo(id: machId, day: DisponibilityDay.saturday.rawValue , start: getDispoTime(mach.saturdayStart), end: getDispoTime(mach.saturdayEnd))
                }
                if mach.sundayActivated {
                    try insertResDispo(id: machId, day: DisponibilityDay.sunday.rawValue , start: getDispoTime(mach.sundayStart), end: getDispoTime(mach.sundayEnd))
                }
            }
        }
        catch {
            // Catch any other errors
        }
    }
    
    
    /// Get time of disponibility from date
    /// - Parameter date: Date to get string from
    /// - Returns: String with time
    func getDispoTime(_ date : Date?) -> String {
        if let time = date {
            let df = DateFormatter()
            df.dateFormat = "HH:mm"
            return df.string(from: time)
        }
        return ""
    }
    
    /// Insert disponibility for resource
    /// - Parameters:
    ///   - id: String with identifier of resource
    ///   - day: String with value representing disponibility day type
    ///   - start: String with hours for start of the disponibility
    ///   - end:  String with hours for end of the disponibility
    /// - Throws: SQLiteError
    func insertResDispo(id: String, day: String, start: String, end: String) throws {
        let insertSql = ResCalendar.insertStatement
        let insertStatement = try prepareStatement(sql: insertSql)
        
        defer {
            sqlite3_finalize(insertStatement)
        }
        guard
            sqlite3_bind_text(insertStatement, 1, (id as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 2, (day as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 3, (start as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 4, (end as NSString).utf8String, -1, nil) == SQLITE_OK
        else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
    }
    
    /// Get all operations in AJobs table
    /// - Returns: Array of AJobs entries
    func getJobs() -> [AJobs]{
        
        var array: [AJobs] = []
        
        let querySql = "SELECT jobId, deadline, priority, instTime, iterations, duration, machineId FROM AJobs;"
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return []
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            let priority = sqlite3_column_int(queryStatement, 2)
            let instTime = sqlite3_column_int(queryStatement, 3)
            let iterations = sqlite3_column_int(queryStatement, 4)
            let duration = sqlite3_column_int(queryStatement, 5)
            
            guard let jobIDquery = sqlite3_column_text(queryStatement, 0) else {
                return []
            }
            
            guard let deadlinequery = sqlite3_column_text(queryStatement, 1) else {
                return []
            }
            
            guard let machineIDquery = sqlite3_column_text(queryStatement, 6) else {
                return []
            }
            
            let jobID = String(cString: jobIDquery) as NSString
            let deadline = String(cString: deadlinequery) as NSString
            let machineID = String(cString: machineIDquery) as NSString
            
            let job = AJobs(jobId: jobID, deadline: deadline, priority: priority, instTime: instTime, duration: duration, iterations: iterations, machineID: machineID)
            array.append(job)
        }
        return array
    }
    
    /// Get all scheduled events for particular Oprtn
    /// - Parameter jobID: identifier of Oprtn
    /// - Returns: Array of ScheduleEvent for operation
    func getEventsByJobID(jobID: String) -> [ScheduleEvent]{
        
        var array: [ScheduleEvent] = []
        
        let querySql = ScheduleEvent.selectStatement
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return []
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        do {
            guard sqlite3_bind_text(queryStatement, 1, (jobID as NSString).utf8String, -1, nil) == SQLITE_OK else {
                throw SQLiteError.Bind(message: errorMessage)
            }
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {

                
                guard let jobIDquery = sqlite3_column_text(queryStatement, 0) else {
                    throw SQLiteError.Scheduled
                }
                guard let machineIDquery = sqlite3_column_text(queryStatement, 1) else {
                    throw SQLiteError.Scheduled
                }
                guard let blockquery = sqlite3_column_text(queryStatement, 2) else {
                    throw SQLiteError.Scheduled
                }
                guard let startquery = sqlite3_column_text(queryStatement, 3) else {
                    throw SQLiteError.Scheduled
                }
                guard let endquery = sqlite3_column_text(queryStatement, 4) else {
                    throw SQLiteError.Scheduled
                }
                let iterations = sqlite3_column_int(queryStatement, 5)

                let jobID = String(cString: jobIDquery) as NSString
                let start = String(cString: startquery) as NSString
                let end = String(cString: endquery) as NSString
                let machineID = String(cString: machineIDquery) as NSString
                let block = String(cString: blockquery) as NSString

                let event = ScheduleEvent(jobId: jobID, resId: machineID, blkCode: block, start: start, end: end, iterations: iterations)
                array.append(event)
            }
        } catch {
            return array
        }
        
        return array

    }
    
    /// Check if table ResCalendar contains resource of the operation
    /// - Parameter operation: Oprtn object for which to check if table ResCalendar contains resource
    /// - Throws: SQLiteError
    /// - Returns: Boolean value if database contains resource of the operation
    func containsResource(operation: Oprtn) throws -> Bool  {
        
        guard let id = operation.machineID else {
            throw SQLiteError.InvalidData(message: "Neznámý zdroj")
        }
        
        let querySql = ResCalendar.selectStatement
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            throw SQLiteError.Prepare(message: errorMessage)
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        guard sqlite3_bind_text(queryStatement, 1, (id as NSString).utf8String, -1, nil) == SQLITE_OK else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(queryStatement) == SQLITE_ROW else {
            return false
        }
        
        guard let _ = sqlite3_column_text(queryStatement, 0) else {
            return false
        }
        return true
    }
    
    
    /// Get calendar of machine
    /// - Returns: Array of ResCalendar entries
    func getCalendarOfMachine(machID: String) throws -> [ResCalendar]{
        
        var array: [ResCalendar] = []
        
        let querySql = ResCalendar.selectStatement
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return []
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        guard sqlite3_bind_text(queryStatement, 1, (machID as NSString).utf8String, -1, nil) == SQLITE_OK else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            guard let idQuery = sqlite3_column_text(queryStatement, 0),
                  let dayQuery = sqlite3_column_text(queryStatement, 1),
                  let startQuery = sqlite3_column_text(queryStatement, 2),
                  let endQuery = sqlite3_column_text(queryStatement, 3)
            else {
                return []
            }
            
            let id = String(cString: idQuery) as NSString
            let day = String(cString: dayQuery) as NSString
            let start = String(cString: startQuery) as NSString
            let end = String(cString: endQuery) as NSString

            let rs = ResCalendar(resid: id, day: day, start: start, end: end)
            array.append(rs)
        }
        return array
    }

    /// Closing and deleting entire database file
    /// - Parameter url: URL to database to delete
    func deleteDB(url: URL) {
        sqlite3_close(dbPointer)
        let fm = FileManager.default
        do {
            try fm.removeItem(at:url)
        } catch {
            NSLog("Error deleting file: \(url)")
        }
    }
    
    func printJob(job: AJobs){
        print("Job id: \(job.jobId )\n  priority: \(job.priority)\n  installation time: \(job.instTime)\n  iteration duration: \(job.duration)\n  iterations: \(job.iterations)\n  deadline: \(job.deadline)\n  machineID: \(job.machineID )\n")
    }
    
    func printEvent(event: ScheduleEvent){
        print("         Event job id: \(event.jobId )\n       machine: \(event.resId)\n       start: \(event.start)\n         end: \(event.end)\n\n")
    }
    
    func printCalendar(res: ResCalendar){
        print("ResCalendar res id: \(res.resid)\n day: \(res.day)\n start: \(res.start)\n end: \(res.end)\n\n")
    }
    
}

extension SQLiteDatabase {
    //Create blank statement
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.Prepare(message: errorMessage)
        }
        return statement
    }
}


