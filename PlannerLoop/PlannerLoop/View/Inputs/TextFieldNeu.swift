//
//  TextFieldNeumorphic.swift
//  PlannerLoop
//
//  Created by Tomáš Tomala
//

import SwiftUI

struct TextFieldNeu: View {
    var label: String = "Label"
    var text : Binding<String>
    var neumorphic : Bool = false
    var background : String = "ContentBackground"

    var body: some View {
        HStack (alignment: .center, spacing: 8){
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
                if(text.wrappedValue.isEmpty){
                    //Label
                    Text(label)
                        .fontWeight(.semibold)
                        .font(.footnote)
                        .foregroundColor(Color("TypographyMedium"))
                        .padding(.horizontal, 5)
                }
                //Text
                TextField("", text: text)
                    .font(.body)
                    .foregroundColor(Color("Typography"))
            }
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 2, height: 30)
                .foregroundColor(Color("Divider"))
            //Erase text
            Button(action: {
                self.text.wrappedValue = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }, label: {
                Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(Color("Typography"))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding(5)
                    .rotationEffect(.init(degrees: 45))
                    .clipped()
            })
        }
        .padding(12.5)
        .background( neumorphic ? AnyView(TextFieldBackground()): AnyView(Color(background)))
        .cornerRadius(10)
        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)

    }
}



struct TextFieldNeu_Previews: PreviewProvider {
    @State static var text = "Cameron Wilson"
    @State static var password = "a"
    static var previews: some View {
        VStack(spacing: 20){
            TextFieldNeu(label: "Username" ,text: $text)
            SecureFieldNeu(label: "Confirm Password" ,password: $text)
        }
    }
}




