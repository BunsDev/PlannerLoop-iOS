//
//
// AddOrEditTemplate.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct AddOrEditTemplate: View {
    var toEdit: Template?

    @State var info: OperationInfo = OperationInfo()
    @State var errorInfo: ToastInfo = ToastInfo()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.horizontalSizeClass) var horizontalSizeClass


    init(template: Template? = nil){
        self.toEdit = template
    }
    
    var body: some View {
        VStack(spacing: 5){
                //Navigation Bar
            TemplateFormNavBar(toEdit: toEdit, info: $info, errorInfo: $errorInfo)
            //Mobile Content
            if horizontalSizeClass != .regular {
                ScrollView(getAxes()){
                    Group{
                        ResourcePicker(info: $info)
                        if let _ = info.resource {
                            DetailsTab(info: $info, deadline: false)
                        }
                        Spacer()
                    } .padding(.horizontal, 10)
                }
            } else { //iPad Content
                HStack {
                    VStack{
                        ResourcePicker(info: $info)
                        Spacer()
                    }
                    ScrollView(){
                        DetailsTab(info: $info, deadline: false)
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .background(Color("Background").ignoresSafeArea())
        .hiddenNavigationBarStyle()
        .toast(isPresenting: $errorInfo.show, duration: 2){
            AlertToast(displayMode: .alert, type: .error(Color("Danger")), title: "Chyba", subTitle: errorInfo.text)
        }
        .onAppear{
            if let temp = toEdit {
                //Load information from edited template
                OperationVM.loadTemplate(template: temp, info: &info)
            }
        }
    }
    
    func getAxes() -> Axis.Set {
        if let _ = info.resource {
            return .vertical
        }
        return []
    }
}
    

struct AddOrEditTemplate_Previews: PreviewProvider {
    static let context = PersistenceController.shared.container.viewContext

    static var previews: some View {
        let template = Template(context: context)
        template.name = "Template name"

        return VStack{
            Spacer()
            AddOrEditTemplate(template: template)
            Spacer()
        }
        .background(Color("Background").ignoresSafeArea())
    }
}

private struct TemplateFormNavBar: View {
    var toEdit: Template?
    @Binding var info: OperationInfo
    @Binding var errorInfo: ToastInfo
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        HStack{
            //Navigation Bar
            NavigationHeader(text: toEdit == nil ? "Nová šablona" : "Editace")
            //Button to confirm new or edited template
            Button(action: {
                OperationVM.shared.addOrEditTemplate(info: info, toEdit: toEdit) { (result: Result<Void, ErrorDescription>) in
                    switch result {
                        case .success():
                            self.presentationMode.wrappedValue.dismiss()
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
        .padding(.horizontal,15)
        .padding(.vertical, 5)
    }
}
