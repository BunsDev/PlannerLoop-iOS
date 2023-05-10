//
//
// Settings.swift
// PlannerLoop
// Main screen with setting buttons
// Created by Tomáš Tomala
//
	

import SwiftUI

struct Settings: View {
    @EnvironmentObject var auth: AuthenticationVM
    @EnvironmentObject var components: ComponentsVM

    var body: some View {
        VStack(spacing: 0){
            //User email
            Text(UserDefaults.standard.string(forKey: "email") ?? "cameron@williams.com")
                .fontWeight(.semibold)
                .font(.callout)
                .foregroundColor(Color("Typography"))
            //Button list
            SettingsButtonGroup()

            Button(action: {
                components.showSettingsSheet = false
                auth.logout()
            }, label: {
                SettingsButton(image: "xmark", headline: "Odhlášení", divider:false)
                    .padding(5)
                    .background(Color("Background"))
                    .cornerRadius(10)
                    .padding(5)
                    .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
            })
            
        }
    }

}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}




