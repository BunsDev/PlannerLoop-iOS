//
//  Authentification.swift
//  PlannerLoop
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct Authentication: View {
    @State var showRegisterScreen = false
    @EnvironmentObject var auth: AuthenticationVM

    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    if showRegisterScreen {
                        Register()
                    } else {
                        Login()
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .overlay(
                SwitchAuthButton(show: $showRegisterScreen)
                ,alignment: .bottom
            )
        }
        .toast(isPresenting: $auth.errorInfo.show, duration: 2){
            AlertToast(displayMode: .alert, type: .error(Color("Danger")), title: "Chyba přihlášení", subTitle: auth.errorInfo.text)
        }

        .background(
            Color("Background").ignoresSafeArea()
        )
    }
}

struct SwitchAuthButton: View {
    @Binding var show: Bool
    var body: some View {
            Button(action: {
                withAnimation{show.toggle()}
            }){
                Text(show ? "Ještě nemáte" : "Již máte")
                    .fontWeight(.bold)
                    .font(.body)
                    .foregroundColor(.gray)
                Text("účet")
                    .fontWeight(.bold)
                    .font(.body)
                    .foregroundColor(Color("AccentHigh"))
                    .shadow(radius: 10)
                    .padding(.horizontal, -3)
                Text("?")
                    .fontWeight(.bold)
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal, -4)
            }.padding(.bottom, getSafeArea().bottom == 0 ? 15 : 0)
    }
}

    struct Authentication_Previews: PreviewProvider {
        @StateObject static var auth = AuthenticationVM()
        static var previews: some View {
            Authentication()
                .environmentObject(auth)

        }
    }






