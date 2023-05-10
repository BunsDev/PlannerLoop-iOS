//
//
// DefaultDisponibility.swift
// PlannerLoop
// Screen with form to set default disponibility
// Created by Tomáš Tomala
//
    

import SwiftUI

//Disponibility form

struct DefaultDisponibility: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let defaults = UserDefaults.standard
    let keys = UserDefaults.Keys.self
    
    @State var info: DisponibilityInfo = DisponibilityInfo()
    @State var errorInfo: ToastInfo = ToastInfo()
    
    var body: some View {
        VStack(){
            //Navigation bar
            HStack {
                NavigationHeader(text: "Disponibilita")
                Button(action: { //Delete Button
                    ResourceVM.shared.checkDisponibility(info: info) { (result: Result<DisponibilityInfo, ErrorDescription>) in
                        switch result {
                            case .success(let processedInfo):
                                defaults.setDefaultDisponibility(info: processedInfo)
                                self.presentationMode.wrappedValue.dismiss()
                            case .failure(let error):
                                errorInfo.text = error.errorDescription
                                errorInfo.show = true
                        }
                    }
                }, label: {
                    ButtonImageLabel(image: "checkmark", bgColor: "Accent", padding: 15, size: 20)
                })
            }
            .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
            .padding(.vertical, 5)
            .padding(.horizontal)
            //Form
            ScrollView {
                VStack(spacing: 10){
                    Text("Nastavit výchozí disponibilitu")
                        .fontWeight(.semibold)
                        .font(.callout)
                        .foregroundColor(Color("TypographyMedium"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    //Disponibility Picker
                    DisponibilityPicker(info: $info)
                }
                .padding(10)
                .background(Color("ContentBackground"))
                .cornerRadius(10)
                .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
                .padding(.vertical, 5)
                .padding(.horizontal)
                Color.clear.padding(.bottom, 60)
            }

        }
        .background(Color("Background").ignoresSafeArea())
        .hiddenNavigationBarStyle()
        .toast(isPresenting: $errorInfo.show, duration: 2, tapToDismiss: true){
            AlertToast(displayMode: .alert, type: .error(Color("Danger")), title: "Chyba", subTitle: errorInfo.text)
        }
        .onAppear{
            //Load default disponibility into form
            info = ResourceVM.shared.loadDefaultDisponibility()
        }

    }
}




struct DefaultDisponibility_Previews: PreviewProvider {
    static var previews: some View {
        DefaultDisponibility()
    }
}


