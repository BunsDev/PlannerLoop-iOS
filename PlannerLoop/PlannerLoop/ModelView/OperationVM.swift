//
//
// OperationVM.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//


import Foundation
import CoreData
import SwiftUI


class OperationVM {
    
    static let shared = OperationVM()

    /// Load from template to operationinfo
    /// - Parameters:
    ///   - template: Template to load info from
    ///   - info: Structure that holds form values
    static func loadTemplate(template: Template, info: inout OperationInfo){
        info.instTime = template.instTime
        info.iterDuration = template.iterDuration
        info.iterations = String(template.iterations)
        info.name = template.name ?? ""
        info.priority = String(template.priority)
        if let mach = ResourceVM.getMachine(machineID: template.machineID ?? "") {
            info.resource = mach
        } else if let emp = ResourceVM.getEmployee(employeeID: template.machineID ?? "") {
            info.resource = emp
        }
    }

    /// Load from existing operation to operationinfo
    /// - Parameters:
    ///   - operation: Operation to load info from
    ///   - info: Structure that holds form values
    ///   - completing: Boolean value if operation is completing
    static func loadOperation(operation: Oprtn, info: inout OperationInfo, completing: Bool = false){
        info.instTime = operation.instTime
        info.iterDuration = operation.iterDuration
        info.iterations = String(operation.iterations)
        info.name = operation.name ?? ""
        info.priority = String(operation.priority)
        info.deadline = operation.deadline ?? Date()
        if let mach = ResourceVM.getMachine(machineID: operation.machineID ?? "") {
            info.resource = mach
        } else if let emp = ResourceVM.getEmployee(employeeID: operation.machineID ?? "") {
            info.resource = emp
        }
    }
    

    /// Get Oprtn object with specified identifier
    /// - Parameter identifier: Oprtn identifier
    /// - Returns: Oprtn object or null if not found
    static func getOperationById(identifier: String) -> Oprtn? {
        let fetchRequest: NSFetchRequest<Oprtn>
        fetchRequest = Oprtn.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        let context = PersistenceController.shared.container.viewContext
        do {
            return try context.fetch(fetchRequest).first
        } catch{
            return nil
        }
    }
    
    

    /// Get all to be scheduled operations
    /// - Returns: Array of Oprtn objects
    static func getTBSOperations() -> [Oprtn]{
        // Create a fetch request for a to be scheduled operations
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Oprtn>
        fetchRequest = Oprtn.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%@ == status", argumentArray:[OperationStatus.toBeScheduled.rawValue])
        let sorting = NSSortDescriptor(key: "index", ascending: true)
        let sortDescriptors = [sorting]
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    


    
    /// Get all operations of single task
    /// - Parameter taskID: String containing task identifier
    /// - Returns: Array of Oprtn objects
    static func getOpsOfTask(taskID: String) -> [Oprtn] {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Oprtn>
        fetchRequest = Oprtn.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "taskID == %@", argumentArray:[taskID])
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    /// Get date label for cell
    /// - Parameter date: Date to get label from
    /// - Returns: String containing label
    func getDateLabel(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "dd. MM. yyyy HH:mm"
        return df.string(from: date)
    }
    

    /// Get duration label for cell
    /// - Parameter duration: time in seconds in Int32
    /// - Returns: String containing duration
    func getDurationLabel(_ duration : Int32) -> String {
        let seconds: Int32 = duration % 60
        let minutes: Int32 = duration / 60
        if seconds == 0 {
            return "\(minutes) min"
        } else if minutes == 0 {
            return "\(seconds) sek"
        } else {
            return "\(minutes) min \(seconds) sek"
        }
    }
    

    /// Returns stage time range as string
    /// - Parameters:
    ///   - operation: Oprtn to calculate stage time range from
    ///   - stageIndex: index of stage to check
    /// - Returns: Time rande of stage in string
    func getStageTimeRange(operation: Oprtn ,stageIndex : Int) -> String {
        
        if let date = OperationVM.getOperationStart(oper: operation) {
            //Date of stage start
            var startdate = date
            for index in 0..<stageIndex {
                if index == 0 {
                    startdate = startdate.addingTimeInterval(TimeInterval(operation.instTime))
                } else {
                    startdate = startdate.addingTimeInterval(TimeInterval(operation.iterDuration))
                }
            }
            //Date of stage end
            var enddate = startdate
            if stageIndex == 0 {
                enddate = enddate.addingTimeInterval(TimeInterval(operation.instTime))
            } else {
                enddate = enddate.addingTimeInterval(TimeInterval(operation.iterDuration))
            }
            return "\(Calendar.getHoursString(date: startdate)) - \(Calendar.getHoursString(date: enddate))"
        } else {
            return "//:// - //://"
        }
    }
    

    /// Get total time of operation
    /// - Parameter operation: Oprtn to calculate total time from
    /// - Returns: Integer with total time of operation in seconds
    func getTotalOperationDurationInSeconds(operation: Oprtn) -> Int {
        return Int(operation.instTime + Int32(operation.iterations) * operation.iterDuration)
    }
    

    /// Check if installation or iteration ended
    /// - Parameters:
    ///   - operation: Oprtn of which specified stage to check
    ///   - stageIndex: index of stage to check
    /// - Returns: Boolean value if stage ended
    func stageEnded(operation: Oprtn, stageIndex: Int) -> Bool {
        if var date = OperationVM.getOperationStart(oper: operation) {
            for index in 0..<stageIndex+1 {
                if index == 0 {
                    date = date.addingTimeInterval(TimeInterval(operation.instTime))
                } else {
                    date = date.addingTimeInterval(TimeInterval(operation.iterDuration))
                }
            }
            return Date() > date
        }
        return false
    }
    // MARK: OprtnEvent functions

    /// Create new Operation Event from ScheduleEvent entry from Schedule Table
    /// - Parameter event: ScheduleEvent entry from Schedule Table
    static func createEvent(event: ScheduleEvent){
        let context = PersistenceController.shared.container.viewContext
        let operEvent: OprtnEvent = OprtnEvent(context: context)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        operEvent.start = dateFormatter.date(from: event.start as String)
        operEvent.end = dateFormatter.date(from: event.end as String)
        operEvent.iterations = event.iterations
        let operation =  OperationVM.getOperationById(identifier: event.jobId as String)
        operEvent.operation = operation
        operation?.addToEvents(operEvent)
        operEvent.identifier = UUID().uuidString
        try? context.save()
    }
    
    /// Get all events of single operation
    /// - Parameter oper: optional Oprtn object
    /// - Returns: Array of OprtnEvent objects
    static func getEventsOfOperation(oper: Oprtn?) -> [OprtnEvent] {
        guard let operation = oper else {
            return []
        }

        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<OprtnEvent>
        fetchRequest = OprtnEvent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "operation == %@", argumentArray:[operation])
        var events: [OprtnEvent] = []
        do {
            events = try context.fetch(fetchRequest)
        } catch {
            return []
        }
        
        return events
    }
    
    /// Get start of first OprtnEvent
    /// - Parameter oper: Oprtn object
    /// - Returns: Date with start of operation
    static func getOperationStart(oper: Oprtn) -> Date? {
        var events: [OprtnEvent] = OperationVM.getEventsOfOperation(oper: oper)
        events = events.sorted(by: { $0.start ?? Date() < $1.start ?? Date() })  //Get first event
        return events.first?.start
    }
    
    /// Get end of last OprtnEvent
    /// - Parameter oper: Oprtn object
    /// - Returns: Date with end of operation
    static func getOperationEnd(oper: Oprtn) -> Date? {
        var events: [OprtnEvent] = OperationVM.getEventsOfOperation(oper: oper)
        events = events.sorted(by: { $0.end ?? Date() > $1.end ?? Date() }) //Get last event
        return events.first?.end
    }
    
    /// Cycle through all events and calculate minutes that are finished
    /// - Parameter operation: Oprtn object
    /// - Returns: Integer containing number of seconds that passed while completing operation
    static func getSecondsPassed(operation: Oprtn) -> Int {
        let events: [OprtnEvent] = OperationVM.getEventsOfOperation(oper: operation)
        var secondsPassed = 0
        
        events.forEach{ event in
            if let start = event.start, let end = event.end {
                if end < Date() || event.confirmed {
                    //Event is finished or is confirmed, add event duration to seconds passed
                    secondsPassed += Int(end.timeIntervalSince(start))
                } else if start < Date() {
                    //Event is started but not finished, add event duration till current date to seconds passed
                    secondsPassed += Int(Date().timeIntervalSince(start))
                }
            }
        }
        return secondsPassed
    }
    

    /// Get number of iterations completed
    /// - Parameter operation: Oprtn from which to get number of iterations completed
    /// - Returns: Integer with number of iterations completed
    static func getIterationsCompleted(operation: Oprtn) -> Int {
        let secondsPassed = getSecondsPassed(operation: operation)
        let iterationsSeconds = secondsPassed - Int(operation.instTime)
        if operation.iterations != 0 {
            let iterationsPassed = Int(iterationsSeconds / Int(operation.iterDuration))

            return max(0, iterationsPassed)
        }
        return 0
    }
    
    /// Mark all operation events as completed up to specified event or uncompleted after specified event
    /// - Parameter event: OprtnEvent to toggle state of completion for
    /// - Returns: Integer with number of iterations completed
    static func toggleEventCompleted(event: OprtnEvent) {
        var events = getEventsOfOperation(oper: event.operation)
        if event.confirmed {
            //Changing state to unconfirmed. Set unconfirmed to all following events
            events = events.filter { opEvent in
                if let ev1 = opEvent.start, let ev2 = event.start {
                    return ev1 >= ev2
                }
                return false
            }
            for ev in events {
                ev.confirmed = false
            }
        } else {
            //Changing state to confirmed. Set confirmed to all previous events
            //Getting all previous events
            events = events.filter { opEvent in
                if let ev1 = opEvent.start, let ev2 = event.start {
                    return ev1 <= ev2
                }
                return false
            }
            //Marking as confirmed
            for ev in events {
                ev.confirmed = true
            }
        }
    }

    // MARK: Functions to create or edit operations and templates

    /// Create new Template object or edit existing one
    /// - Parameters:
    ///   - info: OperationInfo containing form input from user
    ///   - toEdit: Optional Template object, that may be being edited
    ///   - completion: value describing result of completed operation, contains void on success, error on fail
    func addOrEditTemplate(info: OperationInfo, toEdit: Template? = nil, completion: @escaping (Result<Void, ErrorDescription>) -> Void){
        let context = PersistenceController.shared.container.viewContext
        let template: Template
        var isEditing: Bool = false
        
        //Create new NSManagedObject or edit exiting one
        if let temp = toEdit {
            template = temp
            isEditing = true
        } else {
            template = Template(context: context)
        }
        
        do {
            //Checking selected resource
            template.machineID = try checkResource(resource: info.resource)
            //Checking installation time
            template.instTime = try checkTime(time: info.instTime, error: .invalidInstallTime)
            //Checking iteration time
            template.iterDuration = try checkTime(time: info.iterDuration, error: .invalidIterDuration)
            //Checking iterations count
            template.iterations = try checkIterations(iterations: info.iterations)
            //Checking priority
            template.priority = try checkPriority(priority: info.priority)
            //Checking name of the operation
            template.name = try checkName(name: info.name)
        } catch let err as ErrorDescription {
            completion(.failure(err))
            if isEditing == false {
                //If we are editing already existing object, dont delete
                context.delete(template)
            }
            return
        } catch {
            completion(.failure(ErrorDescription.unknown))
            if isEditing == false {
                //If we are editing already existing object, dont delete
                context.delete(template)
            }
            return
        }
        
        completion(.success(()))
        try? context.save()
    }
    
    /// Create new Oprtn object or edit existing one
    /// - Parameters:
    ///   - info: OperationInfo containing form input from user
    ///   - toEdit: Optional Oprtn object, that may be being edited
    ///   - completion: value describing result of completed operation, contains void on success, error on fail
    func addOrEditOperation(info: OperationInfo, toEdit: Oprtn? = nil, completion: @escaping (Result<Oprtn, ErrorDescription>) -> Void){
        let context = PersistenceController.shared.container.viewContext
        var submitError: ErrorDescription? = nil
        let oper: Oprtn
        var isEditing: Bool = false
        
        //Create new NSManagedObject or edit exiting one
        if let operation = toEdit {
            oper = operation
            isEditing = true
        } else {
            oper = Oprtn(context: context)
        }
        submitError = checkAndProcessOperation(info: info, oper: oper)

        //Checking if error occured
        if let err = submitError {
            completion(.failure(err))
            if isEditing == false {
                //If we are editing already existing object, dont delete
                context.delete(oper)
            }
            return
        }
        
        if isEditing == false {
            oper.status = OperationStatus.toBeScheduled.rawValue
            oper.identifier = UUID().uuidString
            oper.index = getSchedulingIndex()-1
        }
        
        completion(.success(oper))
        try? context.save()
    }
    

    /// Create operation object from AJobs table entry
    /// - Parameters:
    ///   - taskID: task identifier
    ///   - job: AJobs containing updated data
    static func createOperationFromJob(job: AJobs, taskID: String){
        let context = PersistenceController.shared.container.viewContext
        let oper: Oprtn
        oper = Oprtn(context: context)
        oper.identifier = job.jobId as String
        oper.index = 0
        oper.machineID = job.machineID as String
        oper.priority = Int16(job.priority)
        oper.iterations = Int16(job.iterations)
        oper.iterDuration = job.duration
        oper.instTime = job.instTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        oper.deadline = dateFormatter.date(from: job.deadline as String)
        oper.status = OperationStatus.scheduled.rawValue
        oper.taskID = taskID
        oper.name = "Neznámá operace"
        try? context.save()
    }
    
    /// Update operation object from AJobs table entry
    /// - Parameters:
    ///   - oper: Oprtn to update
    ///   - job: AJobs containing updated data
    static func updateOperationFromJob(oper: Oprtn, job: AJobs){
        oper.identifier = job.jobId as String
        oper.index = 0
        oper.machineID = job.machineID as String
        oper.priority = Int16(job.priority)
        oper.iterations = Int16(job.iterations)
        oper.iterDuration = job.duration
        oper.instTime = job.instTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        oper.deadline = dateFormatter.date(from: job.deadline as String)
        oper.name = "Neznámá operace"
    }
    

    
    // MARK: Function to check operation characteristics

    /// Checks details in operationInfo, returns error if found and saves valid information to passed NSManagedObject
    /// - Parameters:
    ///   - info: OperationInfo containing form input from user
    ///   - oper: Oprtn to fill data to from operation info
    /// - Returns: ErrorDescription or null
    func checkAndProcessOperation(info: OperationInfo, oper: Oprtn) -> ErrorDescription?{
        do {
            //Checking selected resource
            oper.machineID = try checkResource(resource: info.resource)
            //Checking deadline of operation
            oper.deadline = try checkDeadline(deadline: info.deadline)
            //Checking installation time
            oper.instTime = try checkTime(time: info.instTime, error: .invalidInstallTime)
            //Checking iteration time
            oper.iterDuration = try checkTime(time: info.iterDuration, error: .invalidIterDuration)
            //Checking iterations count
            oper.iterations = try checkIterations(iterations: info.iterations)
            //Checking priority
            oper.priority = try checkPriority(priority: info.priority)
            //Checking name of the operation
            oper.name = try checkName(name: info.name)
            return nil
        } catch let err as ErrorDescription {
            return err
        } catch {
            return ErrorDescription.unknown
        }
    }
    
    /// If operation doesnt have name, throw error
    /// - Parameter name: Name to check
    /// - Throws: ErrorDescription
    /// - Returns: String containing name
    func checkName(name: String?) throws -> String {
        
        guard let string = name, string != "" else {
            throw ErrorDescription.invalidName
        }
        
        return string
        
    }
    

    /// Check duration of iteration or instalation time
    /// - Parameters:
    ///   - time: String from the form containing time
    ///   - error: Which ErrorDescription to show when error occured
    /// - Throws: ErrorDescription
    /// - Returns: Int32 containing duration of iteration or instalation time in seconds
    func checkTime(time: Int32, error: ErrorDescription ) throws -> Int32 {
        
        if error == .invalidInstallTime {
            if time < 0 {
                throw error            }
        } else if error == .invalidIterDuration {
            if time < 1 {
                throw error
            }
        }
        
        return time
    }
    

    /// If priority is not number, negative or more than ten, throw error
    /// - Parameter priority: String from the form containing number with priority
    /// - Throws: ErrorDescription
    /// - Returns: Int16 containing priority
    func checkPriority(priority: String) throws  -> Int16 {
        
        guard let prio = Int16(priority) else {
            throw ErrorDescription.invalidPriority
        }
        
        if prio < 0 ||  prio > 10 {
            throw ErrorDescription.invalidPriority
        }
        
        return prio
        
    }
    
    /// If there is less than one iteration, throw error
    /// - Parameter iterations: String from the form containing number of iterations
    /// - Throws: ErrorDescription
    /// - Returns: Int16 containing number of iterations
    func checkIterations(iterations: String) throws -> Int16{
        guard let iter = Int16(iterations) else {
            throw ErrorDescription.invalidIterations
        }
        if iter <= 0 {
            throw ErrorDescription.invalidIterations
        }
        return iter
    }
    
    /// Check if deadline is in the past
    /// - Parameter deadline: Date to check
    /// - Throws: invalidDeadline error
    /// - Returns: input Date
    func checkDeadline(deadline: Date) throws -> Date {
        if deadline <= Date() {
            throw ErrorDescription.invalidDeadline
        }
        return deadline
    }

    
    /// Checks if resource exists and has identifier
    /// - Parameter resource: Resource to check
    /// - Throws: ErrorDescription
    /// - Returns: String with resource identifier
    func checkResource(resource: Resource?) throws -> String {
        guard let res = resource else {
            throw ErrorDescription.noResource
        }
        guard let resID = res.identifier else {
            throw ErrorDescription.noResourceID
        }
        return resID
    }
    
    /// Get position index for newly created operation. Returns n+1, where n is number of operations to be scheduled
    /// - Returns:Int32 containing index for new operation
    func getSchedulingIndex() -> Int32 {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<Oprtn> = Oprtn.fetchRequest()
        request.predicate = NSPredicate(format: "%@ == status", argumentArray:[OperationStatus.toBeScheduled.rawValue])
        do {
            return Int32(try context.count(for: request))
        } catch {
            return 0
        }
    }
    
    /// Lower index position of to be scheduled operation
    /// - Parameter operation: operation for which to lower index
    func lowerIndex(operation: Oprtn){
        if(operation.index > 0){
            let fetchRequest: NSFetchRequest<Oprtn> = Oprtn.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "%@ == status AND %@ == index", argumentArray:[OperationStatus.toBeScheduled.rawValue, operation.index - 1])
            let context = PersistenceController.shared.container.viewContext
            do {
                try context.fetch(fetchRequest).first?.index += 1
            } catch{
                return
            }
            operation.index -= 1
        }
    }
    
    /// Increase index position of to be scheduled operation
    /// - Parameter operation: operation for which to increase index
    func increaseIndex(operation: Oprtn){
        let maxIndex = getSchedulingIndex()-1
        if(operation.index < maxIndex){
            let fetchRequest: NSFetchRequest<Oprtn> = Oprtn.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "%@ == status AND %@ == index", argumentArray:[OperationStatus.toBeScheduled.rawValue, operation.index + 1])
            let context = PersistenceController.shared.container.viewContext
            do {
                //Increasing index of to be scheduled operation
                try context.fetch(fetchRequest).first?.index -= 1
            } catch{
                return
            }
            operation.index += 1
        }
    }
    
    /// Delete to be scheduled operation and lower index by one of all following to be scheduled operations
    /// - Parameter operation: Operation object to delete
    func deleteTBSOperation(operation: Oprtn){
        do {
            let fetchRequest: NSFetchRequest<Oprtn> = Oprtn.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%@ == status AND %@ < index", argumentArray:[OperationStatus.toBeScheduled.rawValue, operation.index])
            let context = PersistenceController.shared.container.viewContext
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                //Lowering index for objects with index higher than to be deleted operation
                object.index -= 1
            }
            context.delete(operation)
            try? context.save()
        } catch{
            return
        }
    }
}


