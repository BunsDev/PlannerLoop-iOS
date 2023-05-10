//
//  RootView.swift
//  ToDoListCD
//
//  Created by Tomáš Tomala
//

import SwiftUI
import CoreData

struct RootView: View {
    //Core Data controller
    let persistenceController = PersistenceController.shared
    //ViewModel Enviroment Object
    @StateObject var tasksVM: TasksVM = TasksVM()
    
    var body: some View {
        TasksView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(tasksVM)
            .ignoresSafeArea()
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
