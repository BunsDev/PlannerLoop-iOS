//
//  SecureFieldNeu.swift
//  PlannerLoop
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct SecureFieldNeu: View {
    var label: String = "Label"
    var placeholder: String  = "Placeholder"
    var password: Binding<String>
    var showPasswordButton : Bool = false
    var neumorphic : Bool = false

    @State var showPassword : Bool = false
    var body: some View {
        HStack (spacing: 8){
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
                if(password.wrappedValue.isEmpty){
                    //Label
                    Text(label)
                        .fontWeight(.semibold)
                        .font(.footnote)
                        .foregroundColor(Color("TypographyMedium"))
                    .padding(.horizontal, 5)
                    .padding(.vertical, -5)
                    .multilineTextAlignment(.center)
                }
                if showPassword {
                    //Uncensored password
                    TextField(placeholder, text: password)
                        .font(.headline)
                        .foregroundColor(Color("Typography"))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textContentType(.password)
                } else {
                    //Censored password
                    SecureField(placeholder, text: password)
                        .font(.headline)
                        .foregroundColor(Color("Typography"))
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
            }
            if(showPasswordButton){
                //Show/hide password
                RoundedRectangle(cornerRadius: 2)
                .frame(width: 2, height: 30)
                .foregroundColor(Color("Divider"))
                Button(action: {
                    showPassword.toggle()
                }, label: {
                    Image(systemName: showPassword ? "eye" : "eye.slash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(5)
                        .clipped()
                        .foregroundColor(Color("Typography"))
                })
            }
        }
        .padding(12.5)
        .background( neumorphic ? AnyView(TextFieldBackground()): AnyView(Color("ContentBackground")))
        .cornerRadius(10)
        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
    }
}

struct SecureFieldNeu_Previews: PreviewProvider {
    static var previews: some View {
        SecureFieldNeu(password: .constant(""))
    }
}
