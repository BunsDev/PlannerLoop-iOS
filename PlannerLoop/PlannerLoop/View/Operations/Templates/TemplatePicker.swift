//
//
// TemplatePicker.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct TemplatePicker: View {
    @State var sortKey: ListSortingKey = ListSortingKey.name
    @State var predicate: NSPredicate? = nil
    @Binding var showTemplates: Bool
    @Binding var info: OperationInfo
    var body: some View {
        LabeledContainer(label: "Výběr šablony"){
            if showTemplates {
                //Template list
                ScrollView(.vertical, showsIndicators: false) {
                    TemplateSearchBar(predicate: $predicate)
                    LazyVStack(spacing: 10){
                        DynamicRequest(sortKey: sortKey.rawValue,ascending: true,emptyListString: "Šablony nenalezeny", predicate: predicate, grid: true){ (object: Template) in
                            Button {
                                OperationVM.loadTemplate(template: object, info: &info)
                                showTemplates.toggle()
                                predicate = nil
                            } label: {
                                Group{
                                    TemplateCell(template: object, activated: false, showButtons: false)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.bottom, 5)
                }
                NavigationLink(destination: Templates(), label: { SimpleButton(text: "Spravovat šablony", color: "Background") })
                Divider().padding(.vertical,5)
            }
            Button {
                showTemplates.toggle()
                predicate = nil
            } label: { SimpleButton(text: showTemplates ? "Pokračovat bez šablony" : "Zobrazit šablony", color: "Accent") }
            
        }
    }
    
}

struct TemplateSearchBar: View {
    @Binding var predicate: NSPredicate?
    @State var search:String = ""
    //Search Bar for template picker
    var body: some View {
        TextFieldNeu(label: "Hledat", text: $search, background: "Background")
            .frame(maxWidth: 600)
            .padding(.bottom, 5)
            .padding(.horizontal, 5)
            .onChange(of: search) { value in
                if value != "" {
                    predicate = NSPredicate(format: "name CONTAINS[c] %@", value)
                } else {
                    predicate = nil
                }
            }
    }
    
}

struct TemplatePicker_Previews: PreviewProvider {
    static var previews: some View {
        TemplatePicker(showTemplates: .constant(true), info: .constant(OperationInfo()))
    }
}
