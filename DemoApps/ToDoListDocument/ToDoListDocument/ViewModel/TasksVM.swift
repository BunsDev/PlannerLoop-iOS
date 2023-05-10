//
//  TasksVM.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import Foundation
import SwiftUI

class TasksVM: ObservableObject {
    @Published var selectedDay: Date = Date()
    @Published var currentMonth: [Date] = []

    @Published var tasks: [Task] = []
    @Published var tasksOfSelectedDay: [Task] = []

    @Published var showDetail: Bool = false
    @Published var selectedTask: Task?
    
    var document: DocumentPersistance?
    var documentURL: URL?
    
    init() {
        fetchCurrentMonth()
        getTasksOfDay(selectedDay)
    }
    
    //_________________________________________________________________________________________________________
    func createTask(title: String, desc: String, due: Date){
        let newTask = Task(title: title, description: desc, due: due)
        tasks.append(newTask)
        getTasksOfDay(selectedDay)
    }
    //_________________________________________________________________________________________________________
    func deleteTask(task: Task){
        tasks.remove(at: tasks.firstIndex(of: task)!)
        hideTaskDetail()
        getTasksOfDay(selectedDay)
    }
    //_________________________________________________________________________________________________________
    func editTask(title: String, desc: String, due: Date, task: Task?){
        if let row = tasks.firstIndex(where: {$0.id == task?.id}) {
            tasks[row].title = title
            tasks[row].description = desc
            tasks[row].due = due
            getTasksOfDay(selectedDay)
        }
    }
    //_________________________________________________________________________________________________________
    //Hides popup with details of selected task
    func hideTaskDetail(){
        withAnimation(.easeInOut){
            showDetail = false
            selectedTask = nil
        }
    }
    //_________________________________________________________________________________________________________
    //Shows popup with details of selected task
    func showTaskDetail(task: Task){
        withAnimation(.easeInOut){
            showDetail = true
            selectedTask = task
        }
    }
    //_________________________________________________________________________________________________________
    //Get days of current month
    func fetchCurrentMonth(){
        let today = Date()
        let calendar = Calendar.current
        let month = calendar.dateInterval(of: .month, for: today)
        
        guard let firstDay = month?.start else {
            return
        }
        
        guard let lastDay = month?.end else {
            return
        }
        let daysCount = calendar.numberOfDaysBetween(from: firstDay, to: lastDay)
    
        (0...daysCount-1).forEach { day in
            if let dayInMonth = calendar.date(byAdding: .day, value: day, to: firstDay){
                currentMonth.append(dayInMonth)
            }
        }
    }
    
    //Filter and extract tasks for the selected date
    func getTasksOfDay(_ date : Date){
        let selectedDayTasks = self.tasks.filter {
            return Calendar.current.areTheSameDay(first: $0.due, second: date)
        }
        .sorted { task1, task2 in
            return task1.due < task2.due
        }
        
        DispatchQueue.main.async {
            withAnimation(){
                self.tasksOfSelectedDay = selectedDayTasks
            }
        }
    }
    //_________________________________________________________________________________________________________
    //Loads tasks from document saved in local filesystem
    func startup(){
        //shared instance of the FileManager class to get the location of the Documents directory for the current user
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory,
                                     in: .userDomainMask)
        documentURL = dirPaths[0].appendingPathComponent("todo.data")

        document = DocumentPersistance(fileURL: documentURL!)
        document?.tasks = []

        if filemgr.fileExists(atPath: (documentURL?.path)!) {
            //Document exists, load tasks to ViewModel
            document?.open(completionHandler: {(success: Bool) -> Void in
                if success {
                    self.tasks = self.document?.tasks ?? []
                    self.getTasksOfDay(self.selectedDay)
                } else {
                    fatalError("DocumentUI open failure")
                }
            })
        } else {
            //Document doesnt yet exist, create one
            document?.save(to: documentURL!, for: .forCreating,
                     completionHandler: {(success: Bool) -> Void in
                if !success {
                    fatalError("DocumentUI creation failure")
                }
            })
        }
    }
    //_________________________________________________________________________________________________________
    //method to save the user’s tasks to the file system
    func saveTasks(){
        document?.tasks = tasks
        document?.save(to: documentURL!, for: .forOverwriting){ (success: Bool) -> Void in
            if !success {
                fatalError("File overwrite failed")
            }
        }
    }

    
}


