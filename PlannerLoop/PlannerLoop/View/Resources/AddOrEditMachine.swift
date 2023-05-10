//
//
// AddOrEditMachine.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct AddOrEditMachine: View {
    @State var info: ResourceInfo = ResourceInfo()
    @State var errorInfo: ToastInfo = ToastInfo()
    @State var successToast: Bool = false
    var edit: Bool = false
    var machine: Machine?

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var components: ComponentsVM
    
    @State private var presentAlert = false
    
    init(machine: Machine? = nil) {
        self.machine = machine
        if let _ = machine {
            self.edit = true
        }
    }
    
    var body: some View {
        VStack(spacing: 15){
            AddOrEditHeader(edit: edit, editString: "Editace", addString: "Přidání stroje", presentAlert: $presentAlert)
                .alert(isPresented: $presentAlert) {
                    deleteAlert()
                }
            VStack(){
                ScrollView{
                    //Form
                    VStack{
                        TextFieldNeu(label: "Název stroje", text: $info.name)
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
                        ResourceVM.shared.addOrEditMachine(info: info, machine: machine) { (result: Result<Void, ErrorDescription>) in
                            switch result {
                                case .success():
                                    if edit {
                                        self.presentationMode.wrappedValue.dismiss()
                                    } else {
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
            if let toEdit = machine {
                ResourceVM.shared.loadMachine(mach: toEdit, info: &info)
            } else {
                info.disponibility = ResourceVM.shared.loadDefaultDisponibility()
            }
        }
    }
    ///Show alert for deletion
    private func deleteAlert() -> Alert {
        return Alert(
            title: Text("Smazat stroj"),
            message: Text("Tato operace je nenávratná"),
            primaryButton: .default(Text("Zrušit"), action: {}),
            secondaryButton: .destructive(Text("Smazat"), action: {
                //Delete machine
                if let machineToEdit = machine {
                    moc.delete(machineToEdit)
                    try? moc.save()
                }
            })
        )
    }
    
    private func clearFields(){
        info.name = ""
        info.disponibility = ResourceVM.shared.loadDefaultDisponibility()
    }
}

struct AddOrEditMachine_Previews: PreviewProvider {
    static var previews: some View {
        AddOrEditMachine()
    }
}


