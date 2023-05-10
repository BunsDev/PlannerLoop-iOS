//
//
// AddOrEditEmployee.swift
// PlannerLoop
// Screen to edit employee object
// Created by Tomáš Tomala
//
	

import SwiftUI

struct AddOrEditEmployee: View {
    
    @State var info: ResourceInfo = ResourceInfo()
    @State var errorInfo: ToastInfo = ToastInfo()
    @State var successToast: Bool = false

    var edit: Bool = false
    var employee: Employee?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var components: ComponentsVM

    @State private var presentAlert = false
    
    init(employee: Employee? = nil) {
        self.employee = employee
        if let _ = employee {
            self.edit = true
        } 
    }
    
    var body: some View {
        VStack(spacing: 15){
            //Navigatiion bar
            AddOrEditHeader(edit: edit, editString: "Editace", addString: "Přidání zaměstnance", presentAlert: $presentAlert)
                .alert(isPresented: $presentAlert) {
                    deleteAlert()
                }
            VStack{
                ScrollView {
                    //Form
                    VStack {
                        TextFieldNeu(label: "Jméno", text: $info.name)
                        TextFieldNeu(label: "Příjmení", text: $info.lastname)
                        VStack(){
                            HStack {
                                Text("Časová disponibilita")
                                    .fontWeight(.semibold)
                                    .font(.footnote)
                                    .foregroundColor(Color("TypographyMedium"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                            }
                            .padding(.horizontal, 5)
                            DisponibilityPicker(info: $info.disponibility)

                        }
                            .padding(8)
                            .background(Color("ContentBackground"))
                            .cornerRadius(10)
                            .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)

                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    //Confirm button
                    Button(action: {
                        ResourceVM.shared.addOrEditEmployee(info: info, employee: employee) { (result: Result<Void, ErrorDescription>) in
                            switch result {
                                case .success():
                                    if edit { self.presentationMode.wrappedValue.dismiss() }
                                    else {
                                        successToast = true
                                        clearFields()
                                    }
                                case .failure(let error):
                                    errorInfo.text = error.errorDescription
                                    errorInfo.show = true
                            }
                        }
                    }, label: {
                        SimpleButton(text: "Potvrdit")
                    })
                    Color(.clear) //ScrollView Bottom Padding for tabbar
                        .padding(.bottom, 60)
                }
                

                
            }
            .toast(isPresenting: $errorInfo.show, duration: 1, tapToDismiss: true){
                AlertToast(displayMode: .alert, type: .error(Color("Danger")), title: "Chyba", subTitle: errorInfo.text)
            }
            .toast(isPresenting: $successToast, duration: 1, tapToDismiss: true){
                AlertToast(displayMode: .alert, type: .complete(Color("Accent")), title: "Vytvořen záznam stroje")
            }
            Spacer()
        }
        .background(Color("Background").ignoresSafeArea())
        .hiddenNavigationBarStyle()
        .onAppear{
            if let toEdit = employee {
                ResourceVM.shared.loadEmployee(emp: toEdit, info: &info)
            } else {
                info.disponibility = ResourceVM.shared.loadDefaultDisponibility()
            }
        }
    }
    
    ///On succesful submit clear all fields
    private func clearFields(){
        info.name = ""
        info.lastname = ""
        info.disponibility = ResourceVM.shared.loadDefaultDisponibility()
    }
    
    ///On delete attempt show warning
    private func deleteAlert() -> Alert {
        return Alert(
            title: Text("Smazat záznam zaměstnance"),
            message: Text("Tato operace je nenávratná"),
            primaryButton: .default(Text("Zrušit"), action: {}),
            secondaryButton: .destructive(Text("Smazat"), action: {
                //Delete employee
                if let employeeToEdit = employee {
                    moc.delete(employeeToEdit)
                    try? moc.save()
                }
            })
        )
    }
}

struct AddOrEditEmployee_Previews: PreviewProvider {
    static var previews: some View {
        AddOrEditEmployee()
    }
}



