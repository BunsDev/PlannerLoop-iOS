//
//
// ApiVM.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//


import Foundation
import CoreData
import SwiftUI

class ApiVM: ObservableObject {
    
    static let shared = ApiVM()
    
    ///Toast info and style
    @Published var toast: AlertToast = AlertToast(displayMode: .hud, type: .error(Color("Danger")), title: "Chyba", subTitle: "Neznámá chyba")
    @Published var networkingErrorInfo: ToastInfo = ToastInfo()
    
    ///Timer to periodically send api request
    @Published var schedulingTaskTimer: Timer?
    
    ///Value for testing indicating that all operations information should be printed
    static var verbosePrint: Bool = false
    
    ///Array with tasks ids to periodically ask status on
    var schedulingTasksIDs: [String] = [] {
        didSet {
            //If there is some currently scheduling task and timer is not already going, setup timer for api calls
            DispatchQueue.main.async {
                self.schedulingTaskTimer = self.schedulingTimer()
            }
        }
    }
    
    /// Function of timer
    /// For every task in schedulingTasksIDs, request for status of task is sent to the API
    /// if Task is scheduled, API request for task download is sent, if Task failed, operations are marked with error
    /// Toast is shown wit update information
    private func schedulingTimer() -> Timer {
        return Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            var error: ErrorDescription?
            let group: DispatchGroup = DispatchGroup()
            var updateCounter = 0
            for task in self.schedulingTasksIDs {
                group.enter()
                APIService.shared.getTaskStatus(taskID: task){ (result: Result<TaskStatus, ErrorDescription>) in
                        switch result {
                            case .success(let status):
                                if status == TaskStatus.scheduled {
                                    self.downloadTask(taskID: task) { (result: Result<Int, ErrorDescription>) in
                                        switch result {
                                            case .success(let counter):
                                                updateCounter += counter
                                                self.schedulingTasksIDs.removeAll { $0 == task }
                                                APIService.shared.closeOperation(taskID: task) { (closeError: ErrorDescription?) in
                                                    if let err = closeError {
                                                        error = err
                                                    }
                                                }
                                                group.leave()
                                        case .failure( _):
                                                error = .invalidScheduled
                                                group.leave()
                                        }
                                    }
                                } else if status == TaskStatus.failed {
                                    self.schedulingTasksIDs.removeAll { $0 == task }
                                    error = .notScheduled
                                    group.leave()
                                }
                            case .failure(let err):
                                self.schedulingTasksIDs.removeAll { $0 == task }
                                error = err
                                group.leave()
                        }
                }
            }
            
            group.notify(queue: .main) {
                if self.schedulingTasksIDs.isEmpty {
                    timer.invalidate()
                }
                
                if let err = error {
                    //Show error
                    var title = err.errorDescription
                    if err == .notScheduled {
                        title = "Serverová chyba rozvrhování operace"
                    } else if err == .invalidScheduled {
                        title = "Chyba při zpracování rozvrhnuté operace"
                    }
                    ApiVM.shared.networkingErrorInfo.text = "Úspěšně rozvrženo operací: \(updateCounter)"
                    ApiVM.shared.toast = AlertToast(displayMode: .hud, type: .error(Color("Danger")), title: title, subTitle: ApiVM.shared.networkingErrorInfo.text)
                    ApiVM.shared.networkingErrorInfo.show = true
                } else {
                    if updateCounter > 0 {
                        //Show toast
                        ApiVM.shared.networkingErrorInfo.text = "Úspěšně rozvrženo operací: \(updateCounter)"
                        ApiVM.shared.toast = AlertToast(displayMode: .hud, type: .complete(Color("Accent")), title: "Aktualizace", subTitle: ApiVM.shared.networkingErrorInfo.text)
                        ApiVM.shared.networkingErrorInfo.show = true
                    }
                }
            }
        }
    }
    
    
    ///Get all tasks of user that are scheduled and downloaded them
    func downloadSchedulingOperations(completion: @escaping (Result<Int,ErrorDescription>) -> Void) {
        var error: ErrorDescription?
        APIService.shared.getUserOperations() {(result: Result<[DBTask]?, ErrorDescription>) in
            switch result {
            case .success(let tasksArray):
                var updateCounter = 0
                let group: DispatchGroup = DispatchGroup()
                if let array = tasksArray {
                    array.forEach { task in
                         if task.Status == 4 {
                            group.enter()
                            //Task is not closed, canceled or faile
                            self.downloadTask(taskID: task.TaskID) { (result: Result<Int, ErrorDescription>) in
                                switch result {
                                    case .success(let counter):
                                        updateCounter += counter
                                        //No error encountered while downloading task Close the task
                                        APIService.shared.closeOperation(taskID: task.TaskID) { (closeError: ErrorDescription?) in
                                            if let err = closeError {
                                                error = err
                                            }
                                        }
                                        group.leave()
                                    case .failure(let opError):
                                        error = opError
                                        if error == ErrorDescription.invalidDownloadedFile {
                                            APIService.shared.closeOperation(taskID: task.TaskID) { (closeError: ErrorDescription?) in
                                                if closeError == ErrorDescription.cannotClose {
                                                    error = ErrorDescription.cannotCloseFailed
                                                } else {
                                                    error = closeError
                                                }
                                            }
                                            //Update status on the failed process
                                            for op in OperationVM.getOpsOfTask(taskID: task.TaskID) {
                                                op.status = OperationStatus.failed.rawValue
                                            }
                                        }
                                    group.leave()
                                }
                            }
                        } else if task.Status < 4 {
                            //Add to list awaiting for download
                            self.schedulingTasksIDs.append(task.TaskID)
                        }
                    }
                }
                group.notify(queue: .main) {
                    if let err = error {
                        completion(.failure(err))
                    }
                    completion(.success(updateCounter))
                }
            case .failure(let opError):
                print(opError.errorDescription ?? "Error while downloading scheduling operations")
                completion(.failure(opError))
                return
            }
        }
    }
    
    /// Function to start API call to download task
    /// - Parameters:
    ///   - taskID: identifier of task that is to be downloaded
    ///   - completion: value describing result of completed operation, contains void on success, error on fail
    func downloadTask(taskID: String, completion: @escaping (Result<Int,ErrorDescription>) -> Void){
        var data: Data?
        APIService.shared.downloadTask(taskID: taskID) {(result: Result<String, ErrorDescription>) in
        switch result {
            case .success(let fileEncoded):
                var updateCounter = 0
                //Assign taskid to operations and set them as scheduled
                data = Data(base64Encoded: fileEncoded, options: .ignoreUnknownCharacters)
                do {
                    let path = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(SQLiteDatabase.downloadedDBFilename)
                    try? FileManager.default.removeItem(at:path)
                    try data?.write(to: path)
                    try self.proccessDownloadedTask(taskID: taskID, updateCounter: &updateCounter)
                    completion(.success(updateCounter))
                } catch {
                    completion(.failure(.invalidDownloadedFile))
                    return
                }
            case .failure(let opError):
                completion(.failure(opError))
                return
            }
        }
    }
    
    /// Function opens received database from API, opens it and for every operation all scheduled events are added to local data
    /// - Parameters:
    ///   - taskID: identifier of task that is received
    ///   - updateCounter: number of operations, that are being updated
    /// - Throws: throws error ErrorDescription
    func proccessDownloadedTask(taskID: String, updateCounter: inout Int) throws {
        var error: ErrorDescription?
        let db: SQLiteDatabase
        let dbUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(SQLiteDatabase.downloadedDBFilename)
        db = try SQLiteDatabase.open(dbUrl: dbUrl)
        let jobs: [AJobs] = db.getJobs()
        if ApiVM.verbosePrint {
            print("-------------- SCHEDULED DB FILE --------------")
            let cals = try db.getCalendarOfMachine(machID: "Mach1")
            for cal in cals {
                db.printCalendar(res: cal)
            }
        }
        for job in jobs {
            if ApiVM.verbosePrint {
                db.printJob(job: job)
            }
            //Checking if every AJob is represented locally as operation
            var scheduleEvents: Bool = true
            if let op = OperationVM.getOperationById(identifier: job.jobId as String) {
                //Find already existing operation
                if op.status != OperationStatus.completed.rawValue && op.status != OperationStatus.scheduled.rawValue {
                    //Check if operation isnt already marked as completed or scheduled, if not, mark as scheduled and schedule events
                    op.status = OperationStatus.scheduled.rawValue
                } else {
                    //Operation has already been scheduled or marked as complete, dont schedule events
                    scheduleEvents = false
                }
            } else {
                //Create new operation
                OperationVM.createOperationFromJob(job: job, taskID: taskID)
            }
            if scheduleEvents {
                updateCounter += 1
                //Get scheduled events with operations jobid
                let events = db.getEventsByJobID(jobID: job.jobId as String)
                if events.isEmpty {
                    error = .invalidScheduled
                    let op = OperationVM.getOperationById(identifier: job.jobId as String)
                    op?.status = OperationStatus.failed.rawValue
                }
                //create scheduled events
                for event in events {
                    //db.printEvent(event: event)
                    DispatchQueue.main.async {
                        OperationVM.createEvent(event: event)
                    }
                }
            }
        }
        ApiVM.verbosePrint = false
        if let err = error {
            throw err
        }
    }
    
    /// Creates new database for API input and creates needed tables, then fills tables with input for operations, that have status to be scheduled and resources used
    /// - Throws: throws error ErrorDescription
    func buildDatabase(timeZero: Date, specifyTimeZero: Bool) throws {
        let db: SQLiteDatabase
        // File path
        let dbUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(SQLiteDatabase.dbFilename)
        try? FileManager.default.removeItem(at:dbUrl)
        //connection to database.
        db = try SQLiteDatabase.open(dbUrl: dbUrl)
        //creating tables
        try db.createTable(table: ResCalendar.self)
        try db.createTable(table: AJobs.self)
        try db.createTable(table: Opts.self)
        //Getting all operations that are categorized as "to be scheduled"
        let operations = OperationVM.getTBSOperations()
        for operation in operations {
            try db.insertOperation(operation: operation)
            if try db.containsResource(operation: operation) == false {
                try db.insertRes(operation: operation)
            }
        }
        try db.specifyTimezone(timeZero: timeZero, specifyTimeZero: specifyTimeZero)
        
        if ApiVM.verbosePrint {
            print("-------------- CREATED DB FILE --------------")
            let ajobs = db.getJobs()
            for job in ajobs {
                print("Job id: \(job.jobId )\n  priority: \(job.priority)\n  installation time: \(job.instTime)\n  iteration duration: \(job.duration)\n  iterations: \(job.iterations)\n  deadline: \(job.deadline)\n  machineID: \(job.machineID )\n\n")
            }
        }
    }
    
    /// Function to encode database file
    /// - Throws: throws database error converted to ErrorDescription
    /// - Returns: String with database file encoded to Base64
    func getDatabaseEncoded(timeZero: Date, specifyTimeZero: Bool) throws -> String{
        do {
            try buildDatabase(timeZero: timeZero, specifyTimeZero: specifyTimeZero)
            let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(SQLiteDatabase.dbFilename)
            let fileData = try Data.init(contentsOf: filePath)
            let fileStream: String = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
            return fileStream
        } catch let error as SQLiteError {
            throw error.convertToErrDesc()
        } catch {
            throw ErrorDescription.invalidDBFile
        }
    }
    
    /// Main function to prepare database file for API request to submit task
    /// - Parameter completion: value describing result of completed operation, contains void on success, error on fail
    func submitTasks(timeZero: Date, specifyTimeZero: Bool, completion: @escaping (Result<Void,ErrorDescription>) -> Void) {
        let operations = OperationVM.getTBSOperations()

        if operations.isEmpty {
            completion(.failure(.noTBSOperations))
            return
        }
    
        var encodedDB: String = ""
        do {
            encodedDB = try ApiVM.shared.getDatabaseEncoded(timeZero: timeZero, specifyTimeZero: specifyTimeZero)
            var error: ErrorDescription?
            APIService.shared.submitSA(encodedDB: encodedDB) {(result: Result<String, ErrorDescription>) in
            switch result {
                case .success(let taskid):
                    self.schedulingTasksIDs.append(taskid)
                    //Assign taskid to operations and set them as scheduled
                    for operation in operations {
                        operation.taskID = taskid
                        operation.status = OperationStatus.scheduling.rawValue
                    }
                case .failure(let opError):
                    error = opError
                }
            }
            if let err = error {
                throw err
            }
        } catch let err as ErrorDescription {
            completion(.failure(err))
            return
        } catch {
            completion(.failure(.notScheduled))
            return
        }
        completion(.success(()))
    }
    
}
