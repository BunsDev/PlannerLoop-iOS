//
//  RootView.swift
//  ToDoListDocument
//
//  Created by Tomáš Tomala
//

import SwiftUI
import CoreData

struct RootView: View {
    //ViewModel Enviroment Object
    @StateObject var tasksVM: TasksVM = TasksVM()
    
    var body: some View {
        TasksView(){
            tasksVM.saveTasks()
        }
        .environmentObject(tasksVM)
        .ignoresSafeArea()
        .onAppear {
            tasksVM.startup()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
