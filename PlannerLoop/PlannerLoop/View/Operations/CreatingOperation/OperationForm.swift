//
//
// OperationForm.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct OperationForm: View {
    @State var info: OperationInfo = OperationInfo()
    var toEdit: Oprtn?
    var completing: Bool = false
    @State var errorInfo: ToastInfo = ToastInfo()
    @State var showTemplates: Bool = true

    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var components: ComponentsVM

    var body: some View {

        VStack(spacing: 5){
            OperationFormNavBar(toEdit: toEdit, completing: completing, info: $info, errorInfo: $errorInfo)
            if horizontalSizeClass != .regular {
                ScrollView(getAxes()){ //Mobile content
                    Group{
                        TemplatePicker(showTemplates: $showTemplates, info: $info)
                        if !showTemplates {
                            ResourcePicker(info: $info)
                            if let _ = info.resource {
                                DetailsTab(info: $info)
                            }
                        }
                        Spacer()
                    }.padding(.horizontal, 10)
                }
            } else { //iPad Content
                Group{
                    TemplatePicker(showTemplates: $showTemplates, info: $info)
                    if !showTemplates {
                        HStack {
                            VStack {
                                ResourcePicker(info: $info)
                                Spacer()
                            }
                            ScrollView(){
                                DetailsTab(info: $info)
                            }
                        }
                    }
                }.padding(.horizontal, 10)
            }
        }
        .background(Color("Background").ignoresSafeArea())
        .hiddenNavigationBarStyle()
        .toast(isPresenting: $errorInfo.show, duration: 1, tapToDismiss: true){
            AlertToast(displayMode: .alert, type: .error(Color("Danger")), title: "Chyba", subTitle: errorInfo.text)
        }
        .onAppear{
            loadFormInfo()
        }
    }
    
    private func loadFormInfo() {
        //Load template information or information from operation to edit
        if let oper = toEdit {
            OperationVM.loadOperation(operation: oper, info: &info)
            showTemplates = false
        }
        if completing {
            //Load completing operation info into the form
            if let operation = components.operationDetail {
                OperationVM.loadOperation(operation: operation, info: &info, completing: true)
                //Getting remaining iterations
                info.iterations = String(Int(operation.iterations) - OperationVM.getIterationsCompleted(operation: operation))
            }
        }
    }
    
    private func getAxes() -> Axis.Set {
        if let _ = info.resource {
            return .vertical
        }
        return []
    }
}

private struct OperationFormNavBar: View {
    var toEdit: Oprtn?
    var completing: Bool
    @Binding var info: OperationInfo
    @Binding var errorInfo: ToastInfo
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var components: ComponentsVM
    
    var body: some View {
        HStack{
            //Navigation Bar
            NavigationHeader(text: toEdit == nil ? "Nová operace" : "Editace")
            Button(action: {
                OperationVM.shared.addOrEditOperation(info: info, toEdit: toEdit) { (result: Result<Oprtn, ErrorDescription>) in
                    switch result {
                        case .success(let operation):
                            self.presentationMode.wrappedValue.dismiss()
                            if completing {
                                components.operationDetail = operation
                            }
                        case .failure(let error):
                            errorInfo.text = error.errorDescription
                            errorInfo.show = true
                    }
                }
            }, label: {
                ButtonImageLabel(image: "checkmark",  bgColor: (info.resource == nil) ? "Disabled" : "Accent", padding: 15, size: 20)
            })
            .disabled(info.resource == nil)
        }
        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
}


