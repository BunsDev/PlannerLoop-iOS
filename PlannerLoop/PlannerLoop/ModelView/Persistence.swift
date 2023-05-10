//
//
// Persistence.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer
    
    /// Create Persistent Container and load persistent stores
    /// - Parameter inMemory: save data to non-persistent storage ; for debugging
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PlannerLoop")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("CoreData Store Failed \(error), \(error.userInfo)")
            }
        })
    }
    
    
    /// Save unsaved changes
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
            }
        }
    }
}

