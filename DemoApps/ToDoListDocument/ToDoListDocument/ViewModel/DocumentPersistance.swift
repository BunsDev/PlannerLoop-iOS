//
//  DocumentPersistance.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//


import Foundation


import UIKit

class DocumentPersistance: UIDocument {

    var tasks: [Task]?
    
    //_________________________________________________________________________________________________________
    // collect the data to be stored in the document and pass it back to the Document object instance in the form of a Data object to be written to the document
    override func contents(forType typeName: String) throws -> Any {
        do {
            //encode the tasks data
            let data = try JSONEncoder().encode(tasks)
            return data
        } catch {
            return Data()
        }
    }
    //_________________________________________________________________________________________________________
    // responsible for loading and decoding data into the application’s internal data model
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let userContent = contents as? Data {
            do {
                //decode the tasks data
                tasks = try JSONDecoder().decode([Task].self, from: userContent)
            } catch {
                tasks = []
            }
        }
    }
    

}

