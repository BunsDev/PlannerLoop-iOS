//
//  Account.swift
//  PlannerLoop
//
//

import SwiftUI

struct AccountScreen: View {
    @EnvironmentObject var auth: AuthenticationVM
    let email = UserDefaults.standard.string(forKey: "email")

    var body: some View {
        VStack {
            Text(email ?? "")
            Button(action: {
                auth.logout()
            }, label: {
                ButtonNeu(text: "Log out")
                    .foregroundColor(.black)
                    .padding(15)
        })
        }
    }
}

struct Account_Previews: PreviewProvider {
    static var previews: some View {
        AccountScreen()
    }
}
