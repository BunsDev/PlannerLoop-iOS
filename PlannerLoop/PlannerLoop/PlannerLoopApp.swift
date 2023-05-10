//
//  PlannerLoopApp.swift
//  PlannerLoop
//
//  Created by Tomáš Tomala
//

import SwiftUI

@main
struct PlannerLoopApp: App {
    
    @StateObject var auth: AuthenticationVM = AuthenticationVM()
    @StateObject var cmpnts: ComponentsVM = ComponentsVM()
    @StateObject var api: ApiVM = ApiVM.shared
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(auth)
                .environmentObject(cmpnts)
                .environmentObject(api)
                .onAppear(){
                    UIApplication.shared.addTapGestureRecognizer()
                    setupAppearance()
                }
        }
    }
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.init(Color("Accent"))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.init(Color("Accent")).withAlphaComponent(0.2)
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color("Accent"))
    }
}


