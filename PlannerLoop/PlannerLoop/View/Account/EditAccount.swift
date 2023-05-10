//
//
// EditAccount.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct EditAccount: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var auth: AuthenticationVM
    @State var confirmpassword = ""

    var body: some View {
        VStack(){
            NavigationHeader(text: "Upravit Profil")
                .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
                .padding(.horizontal)
                .padding(.vertical, 5)
            ScrollView {
                VStack(spacing: 15){
                    TextFieldNeu(label: "Email", text: $auth.credentials.email)
                        .disabled(true)
                    SecureFieldNeu(label: "Nové heslo", placeholder: "", password: $auth.credentials.password, showPasswordButton: true)
                    SecureFieldNeu(label: "Potvrďte Heslo", placeholder: "", password: $confirmpassword)
                    if(auth.showProgressView) {
                        ProgressView()
                    }
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        SimpleButton(text: "Aktualizovat Heslo")
                            .padding(15)
                    })
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                Color.clear.padding(.bottom, 60)
            }
        }
        .background(Color("Background").ignoresSafeArea())
        .hiddenNavigationBarStyle()
        .toast(isPresenting: $auth.errorInfo.show, duration: 2){
            AlertToast(displayMode: .alert, type: .error(Color("Danger")), title: "Chyba", subTitle: auth.errorInfo.text)
        }
    }

}

struct EditAccount_Previews: PreviewProvider {
    static var previews: some View {
        EditAccount()
            .environmentObject(AuthenticationVM())
    }
}
