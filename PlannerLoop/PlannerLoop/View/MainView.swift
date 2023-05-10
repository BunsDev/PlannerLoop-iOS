//
//
// MainView.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var auth: AuthenticationVM
    @EnvironmentObject var components: ComponentsVM
    @EnvironmentObject var api: ApiVM
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
 
    @State var tabBarIndex: Int = 0
    var body: some View {
        if $auth.isValidated.wrappedValue == false {
            //Login form for nonauthenticated person
            Authentication()
        } else {
            HStack(spacing: 0){
                if horizontalSizeClass == .regular {
                    SideBar(selectedTab: $tabBarIndex)
                }
                ZStack(alignment: .bottom){
                    //Content
                    switch($tabBarIndex.wrappedValue){
                        case 0:
                            Operations()
                        case 1:
                            Resources()
                        case 2:
                            Schedule()
                        default:
                            Operations()
                    }
                    //Tab Bar
                    if components.tabBarShown && horizontalSizeClass != .regular {
                        TabBar(selectedTab: $tabBarIndex)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .toast(isPresenting: $api.networkingErrorInfo.show, duration: 3, tapToDismiss: true){
                    //API progress toast
                    api.toast
                }
            }
            .background(Color("Background").ignoresSafeArea())

        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
