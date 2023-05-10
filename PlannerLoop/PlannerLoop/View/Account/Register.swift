//
//  Register.swift
//  PlannerLoop
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct Register: View {
    @State var confirmpassword = ""
    @EnvironmentObject var auth: AuthenticationVM

    var body: some View {
        VStack(alignment: .center, spacing: 12){
            Spacer()
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
            Text("Vytvořit účet")
                .fontWeight(.bold)
                .font(.title3)
                .foregroundColor(Color("TypographyMedium"))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 20)
            TextFieldNeu(label: "Email", text: $auth.credentials.email)
            SecureFieldNeu(label: "Heslo", placeholder: "", password: $auth.credentials.password, showPasswordButton: true)
            SecureFieldNeu(label: "Potvrďte Heslo", placeholder: "", password: $confirmpassword)
            
            Button(action: {
                //auth.updateValidation(isValidated: true)
            }, label: {
                ButtonAccentNeu(text: "Registrovat")
                    .padding(15)
            })
            Spacer()

        } .padding()
    }
}

struct Register_Previews: PreviewProvider {
    @StateObject static var auth = AuthenticationVM()

    static var previews: some View {
        Register()
            .environmentObject(auth)
    }
}
