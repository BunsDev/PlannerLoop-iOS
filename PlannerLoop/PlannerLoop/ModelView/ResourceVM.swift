//
//
// ResourceVM.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
    

import Foundation
import CoreData


class ResourceVM {
    
    static let shared = ResourceVM()

    /// Get resource name from id
    /// - Parameter resID: ID of the resource to get name for
    /// - Returns: String with name of the resource
    func getResName(resID: String?) -> String? {
        if let mach = ResourceVM.getMachine(machineID: resID ?? "") {
            return "\(mach.name ?? "")"
        } else if let emp = ResourceVM.getEmployee(employeeID: resID ?? "") {
            return "\(emp.name ?? "") \(emp.surname ?? "Unknown")"
        }
        return nil
    }
    
    
    /// Get resource object with id
    /// - Parameter resID: ID of the resource to get
    /// - Returns: Optional resource object
    func getRes(resID: String?) -> Resource? {
        if let id = resID {
            let fetchRequest: NSFetchRequest<Resource>
            fetchRequest = Resource.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", id)
            let context = PersistenceController.shared.container.viewContext
            do {
                return try context.fetch(fetchRequest).first
            } catch{
                return nil
            }
        } else {
            return nil
        }
    }
    
    /// Get machine object with specified identifier
    /// - Parameter machineID: machine identifier
    /// - Returns: Machine object or null if not found
    static func getMachine(machineID: String) -> Machine? {
        let fetchRequest: NSFetchRequest<Machine>
        fetchRequest = Machine.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", machineID)
        let context = PersistenceController.shared.container.viewContext
        
        do {
            return try context.fetch(fetchRequest).first
        } catch{
            return nil
        }
    }
    
    /// Get employee object with specified identifier
    /// - Parameter employeeID: employee identifier
    /// - Returns: Employee object or null if not found
    static func getEmployee(employeeID: String) -> Employee? {
        let fetchRequest: NSFetchRequest<Employee>
        fetchRequest = Employee.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", employeeID)
        let context = PersistenceController.shared.container.viewContext
        
        do {
            return try context.fetch(fetchRequest).first
        } catch{
            return nil
        }
    }
    
    /// Load data from existing Employee to ResourceInfo that holds values for form
    /// - Parameters:
    ///   - emp: Employee object to insert into form
    ///   - info: ResourceInfo structure that holds form values
    func loadEmployee(emp: Employee, info: inout ResourceInfo){
        info.name = emp.name ?? ""
        info.lastname = emp.surname ?? ""
        info.disponibility = loadDisponibility(res: emp)
    }
    
    
    /// Load data from existing Employee to ResourceInfo that holds values for form
    /// - Parameters:
    ///   - mach: Machine object to insert into form
    ///   - info: ResourceInfo structure that holds form values
    func loadMachine(mach: Machine, info: inout ResourceInfo){
        info.name = mach.name ?? ""
        info.disponibility = loadDisponibility(res: mach)
    }
    
    
    /// Load default disponibility from userDefaults
    func loadDefaultDisponibility() -> DisponibilityInfo{
        let defaults = UserDefaults.standard
        let keys = UserDefaults.Keys.self
        
        if let dispo = defaults.object(forKey: keys.disponibility.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let strct = try? decoder.decode(DisponibilityInfo.self, from: dispo) {
                return strct
            } else {
                return DisponibilityInfo()
            }
        }
        return DisponibilityInfo()
    }
    
    ///Create or edit existing employee
    func addOrEditEmployee(info: ResourceInfo, employee: Employee? = nil, completion: @escaping (Result<Void, ErrorDescription>) -> Void){
        let context = PersistenceController.shared.container.viewContext
        let emp: Employee
        var isEditing: Bool = false
        //Create new NSManagedObject or edit exiting one
        if let toEdit = employee {
            emp = toEdit
            isEditing = true
        } else {
            emp = Employee(context: context)
        }
        var submitError: ErrorDescription? = nil
        //Checking times of disponibility
        checkDisponibility(info: info.disponibility) { (result: Result<DisponibilityInfo, ErrorDescription>) in
            switch result {
            case .success(let dispo):
                self.saveDisponibility(res: emp, dispo: dispo)
                case .failure(let error): submitError = error
            }
        }
        //Checking name of resource
        if ( info.name == "" && info.lastname == "" ) {
            submitError = .invalidNameEmployee
        }
        //Checking if error occured
        if let err = submitError {
            completion(.failure(err))
            if isEditing == false {
                //If we are editing already existing object, dont delete
                context.delete(emp)
            }
            return
        }
        
        if isEditing == false {
            emp.identifier = UUID().uuidString
        }

        emp.name = info.name
        emp.surname = info.lastname

        completion(.success(()))
        try? context.save()
    }
    
    ///Create or edit existing machine  
    func addOrEditMachine(info: ResourceInfo, machine: Machine? = nil, completion: @escaping (Result<Void, ErrorDescription>) -> Void){
        let context = PersistenceController.shared.container.viewContext
        let mach: Machine
        var isEditing: Bool = false
        //Create new NSManagedObject or edit exiting one
        if let toEdit = machine {
            mach = toEdit
            isEditing = true
        } else {
            mach = Machine(context: context)
        }
        
        var submitError: ErrorDescription? = nil
        //Checking times of disponibility
        checkDisponibility(info: info.disponibility) { (result: Result<DisponibilityInfo, ErrorDescription>) in
            switch result {
            case .success(let dispo):
                self.saveDisponibility(res: mach, dispo: dispo)
                case .failure(let error): submitError = error
            }
        }
        //Checking name of resource
        if ( info.name == "") {
            submitError = .invalidName
        }
        //Checking if error occured
        if let err = submitError {
            completion(.failure(err))
            if isEditing == false {
                context.delete(mach)
            }
            return
        }
        
        if isEditing == false {
            mach.identifier = UUID().uuidString
        }

        mach.name = info.name

        completion(.success(()))
        try? context.save()
    }
    
    /// Depending on selected type of disponibility, save accordingly info to DisponibilityInfo structure
    func processDisponibility(info: DisponibilityInfo) -> DisponibilityInfo{
        var processedInfo: DisponibilityInfo = info
        if (processedInfo.selectedDay != .individual){
            processedInfo.mondayActivated = true
            //Take mondays start and end and apply it to workdays
            processedInfo.tuesdayActivated = true
            processedInfo.tuesdayStart = processedInfo.mondayStart
            processedInfo.tuesdayEnd = processedInfo.mondayEnd

            processedInfo.wednesdayActivated = true
            processedInfo.wednesdayStart = processedInfo.mondayStart
            processedInfo.wednesdayEnd = processedInfo.mondayEnd
            
            processedInfo.thursdayActivated = true
            processedInfo.thursdayStart = processedInfo.mondayStart
            processedInfo.thursdayEnd = processedInfo.mondayEnd
            
            processedInfo.fridayActivated = true
            processedInfo.fridayStart = processedInfo.mondayStart
            processedInfo.fridayEnd = processedInfo.mondayEnd
            
            if processedInfo.selectedDay == .all {
                //Take mondays start and end and apply it to the rest of the days

                processedInfo.saturdayActivated = true
                processedInfo.saturdayStart = processedInfo.mondayStart
                processedInfo.saturdayEnd = processedInfo.mondayEnd
                
                processedInfo.sundayActivated = true
                processedInfo.sundayStart = processedInfo.mondayStart
                processedInfo.sundayEnd = processedInfo.mondayEnd
            } else {
                processedInfo.saturdayActivated = false
                processedInfo.sundayActivated = false
            }
        }
        return processedInfo
    }

    ///Check times of monday to sunday
    func checkDisponibility(info: DisponibilityInfo, completion: @escaping (Result<DisponibilityInfo, ErrorDescription>) -> Void) {
        let processedInfo = processDisponibility(info: info)
        var disponibilityError: ErrorDescription? = nil
        if processedInfo.mondayActivated { disponibilityError = checkDisponibilityTimes(from: processedInfo.mondayStart, to: processedInfo.mondayEnd) }
        if processedInfo.tuesdayActivated { disponibilityError = checkDisponibilityTimes(from: processedInfo.tuesdayStart, to: processedInfo.tuesdayEnd) }
        if processedInfo.wednesdayActivated { disponibilityError = checkDisponibilityTimes(from: processedInfo.wednesdayStart, to: processedInfo.wednesdayEnd) }
        if processedInfo.thursdayActivated {  disponibilityError = checkDisponibilityTimes(from: processedInfo.thursdayStart, to: processedInfo.thursdayEnd) }
        if processedInfo.fridayActivated {  disponibilityError = checkDisponibilityTimes(from: processedInfo.fridayStart, to: processedInfo.fridayEnd) }
        if processedInfo.saturdayActivated {   disponibilityError = checkDisponibilityTimes(from: processedInfo.saturdayStart, to: processedInfo.saturdayEnd) }
        if processedInfo.sundayActivated {  disponibilityError = checkDisponibilityTimes(from: processedInfo.sundayStart, to: processedInfo.sundayEnd) }

        if let err = disponibilityError {
            completion(.failure(err))
            return
        }
        completion(.success(processedInfo))
    }
    
    ///Load disponibility info to resource
    func saveDisponibility(res: Resource, dispo: DisponibilityInfo) {
        res.disponibilityDay = dispo.selectedDay.rawValue
        
        res.mondayActivated = dispo.mondayActivated
        res.mondayStart = dispo.mondayStart
        res.mondayEnd = dispo.mondayEnd

        res.tuesdayActivated = dispo.tuesdayActivated
        res.tuesdayStart = dispo.tuesdayStart
        res.tuesdayEnd = dispo.tuesdayEnd

        res.wednesdayActivated = dispo.wednesdayActivated
        res.wednesdayStart = dispo.wednesdayStart
        res.wednesdayEnd = dispo.wednesdayEnd
        
        res.thursdayActivated = dispo.thursdayActivated
        res.thursdayStart = dispo.thursdayStart
        res.thursdayEnd = dispo.thursdayEnd
        
        res.fridayActivated = dispo.fridayActivated
        res.fridayStart = dispo.fridayStart
        res.fridayEnd = dispo.fridayEnd
        
        res.saturdayActivated = dispo.saturdayActivated
        res.saturdayStart = dispo.saturdayStart
        res.saturdayEnd = dispo.saturdayEnd
        
        res.sundayActivated = dispo.sundayActivated
        res.sundayStart = dispo.sundayStart
        res.sundayEnd = dispo.sundayEnd
    }
    
    ///Load to resource disponibility info to DisponibilityInfo structure
    func loadDisponibility(res: Resource) -> DisponibilityInfo{
        var dispo: DisponibilityInfo = DisponibilityInfo()
        dispo.selectedDay = DisponibilityDay.init(rawValue: res.disponibilityDay ?? DisponibilityDay.all.rawValue) ?? .all
        
        dispo.mondayActivated = res.mondayActivated
        dispo.mondayStart = res.mondayStart ?? Calendar.current.startOfDay(for: Date())
        dispo.mondayEnd = res.mondayEnd ?? Calendar.getDayEnd()

        dispo.tuesdayActivated = res.tuesdayActivated
        dispo.tuesdayStart = res.tuesdayStart ?? Calendar.current.startOfDay(for: Date())
        dispo.tuesdayEnd = res.tuesdayEnd ?? Calendar.getDayEnd()

        dispo.wednesdayActivated = res.wednesdayActivated
        dispo.wednesdayStart = res.wednesdayStart ?? Calendar.current.startOfDay(for: Date())
        dispo.wednesdayEnd = res.wednesdayEnd ?? Calendar.getDayEnd()
        
        dispo.thursdayActivated = res.thursdayActivated
        dispo.thursdayStart = res.thursdayStart ?? Calendar.current.startOfDay(for: Date())
        dispo.thursdayEnd = res.thursdayEnd ?? Calendar.getDayEnd()
        
        dispo.fridayActivated = res.fridayActivated
        dispo.fridayStart = res.fridayStart ?? Calendar.current.startOfDay(for: Date())
        dispo.fridayEnd = res.fridayEnd ?? Calendar.getDayEnd()
        
        dispo.saturdayActivated = res.saturdayActivated
        dispo.saturdayStart = res.saturdayStart ?? Calendar.current.startOfDay(for: Date())
        dispo.saturdayEnd = res.saturdayEnd ?? Calendar.getDayEnd()
        
        dispo.sundayActivated = res.sundayActivated
        dispo.sundayStart = res.sundayStart ?? Calendar.current.startOfDay(for: Date())
        dispo.sundayEnd = res.sundayEnd ?? Calendar.getDayEnd()
        
        return dispo
    }

    ///Check if "to" time is not before "from" time
    func checkDisponibilityTimes(from: Date, to: Date) -> ErrorDescription?{
        if from >= to {
            return .invalidDisponibilityTimes
        }
        return nil
    }
    
}
