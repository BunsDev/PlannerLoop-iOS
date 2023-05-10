//
//  Login.swift
//  PlannerLoop
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct Login: View {
    @EnvironmentObject var auth: AuthenticationVM

    var body: some View {
        VStack(alignment: .center, spacing: 12){
            Spacer()
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
            Text("Pokračujte přihlášením")
                .fontWeight(.bold)
                .font(.title3)
                .foregroundColor(Color("TypographyMedium"))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 20)
            TextFieldNeu(label: "Email", text: $auth.credentials.email)
            SecureFieldNeu(label: "Heslo", placeholder: "", password: $auth.credentials.password, showPasswordButton: true)
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Zapomenuté heslo?")
                    .fontWeight(.bold)
                    .font(.callout)
                    .foregroundColor(Color("TypographyMedium"))
            })
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(10)
            if(auth.showProgressView) {
                ProgressView()
            }
            Button(action: {
                auth.login()
            }, label: {
                getLoginButton()
            }).disabled(auth.loginDisabled)
            Spacer()
        }
        .padding()
        .disabled(auth.showProgressView)
    }
    
    /// Change button depending on the state of the form
    private func getLoginButton() -> some View {
        return Group {
            if auth.loginDisabled {
                ButtonNeu(text: "Přihlásit se")
            } else {
                ButtonAccentNeu(text: "Přihlásit se")
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    @StateObject static var auth = AuthenticationVM()

    static var previews: some View {
        Authentication()
            .environmentObject(auth)
    }
}
