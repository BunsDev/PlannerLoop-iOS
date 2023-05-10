//
//
// OperationDetail.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct OperationDetail: View {
    
    //Alerts and toasts
    @State private var presentCompleteAlert = false
    @State private var presentUncompleteAlert = false
    @State private var presentDeleteAlert = false
    
    //Navigation link
    @State var completeOperation: Bool = false

    //Operation to show
    @Binding var oper: Oprtn?

    @EnvironmentObject var components: ComponentsVM
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ScrollView {
                HStack{
                    NavigationHeader(text: oper?.name ?? "Neznámý název")
                    //Delete Button
                    if let _ = oper {
                        Button(action: {  presentDeleteAlert = true }
                               , label: { ButtonImageLabel(image: "trash",  bgColor: "Danger", padding: 15, size: 20) })
                    }
                }
                .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .alert(isPresented: $presentDeleteAlert) { deleteAlert() }
            if let operation = oper {
                OperationDetailInfo(operation: operation)
                if isStatus(.scheduled) || isStatus(.completed) {
                    LabeledDivider(label: isStatus(.completed) ? "Dokončeno": "Akce")
                    //Events
                    LazyVStack {
                        Divider()
                        DynamicRequest(sortKey: ListSortingKey.start.rawValue, ascending: true, emptyListString: "Akce nenalezeny", predicate: getEventPredicate()){ (object: OprtnEvent) in
                            EventButton(operation: operation, event: object)
                        }
                    }
                    .padding(10)
                    .background(Color("ContentBackground").cornerRadius(10).shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3))
                    .padding(.horizontal, 10)
                    .padding(.bottom, 5)
                    //Complete operation Button
                    if isStatus(.scheduled) {
                        markAllButton()
                            .actionSheet(isPresented: $presentUncompleteAlert) { uncompleteAlert() }
                        Button(action: {
                            handleCompleteButton()
                        }, label: { SimpleButton(text: "Dokončit operaci", color: "Accent").padding(.top, 5) })
                        .actionSheet(isPresented: $presentCompleteAlert) { completeAlert() }
                    }
                }
                Color(.clear).padding(.bottom, 60)  //ScrollView Bottom Padding for tabbar
                NavigationLink(destination: OperationForm(completing: true), isActive: self.$completeOperation) { EmptyView() }
            } else {
                Text("Operace nenalezena")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(10)
                    .foregroundColor(Color("TypographyMedium"))
            }
        }
        .background(Color("Background").ignoresSafeArea())
        .hiddenNavigationBarStyle()
        .onAppear{ components.hideTabBar()}
    }
    
    
    /// Creates predicate for query to get events of specified operation
    /// - Returns: NSPredicate for operations
    func getEventPredicate() -> NSPredicate? {
        if let operation = oper {
            return NSPredicate(format: "operation == %@", argumentArray:[operation])
        }
        return nil
    }
    
    /// Returns boolean value whether operation is specified status
    /// - Parameter isState: operation status
    /// - Returns: true if operation is state specified as paramter
    func isStatus(_ isState: OperationStatus) -> Bool{
        if let operation = oper {
            return operation.status == isState.rawValue
        } else {
            return false
        }
    }
    
    /// Determine which alert to show
    func handleCompleteButton() {
        if let operation = oper {
            var events: [OprtnEvent] = OperationVM.getEventsOfOperation(oper: operation)
            events = events.filter { $0.confirmed == false}
            if events.isEmpty {
                presentCompleteAlert.toggle()
           } else {
                presentUncompleteAlert.toggle()
           }
        }
    }
    
    /// Present alert on complete operation request while there are uncompleted stages
    /// - Returns: ActionSheet object
    private func uncompleteAlert() -> ActionSheet {
        return ActionSheet(title: Text("Ukončení operace"), message: Text("Chystáte se ukončit operaci s nepotvrzenými iteracemi. Nepotvrzené iterace budou smazány. Tato akce je nevratná."), buttons: [
            .default(Text("Vytvořit dokončující operaci")) {
                //Deleting all unconfirmed events
                let events: [OprtnEvent] = OperationVM.getEventsOfOperation(oper: oper)
                events.forEach{ event in
                    if event.confirmed == false {
                        moc.delete(event)
                    }
                }
                try? moc.save()
                self.completeOperation = true
            },
            .default(Text("Nevytvářet")) {
                if let operation = oper {
                    operation.status = OperationStatus.completed.rawValue
                    try? moc.save()
                }
                //Deleting all unconfirmed events
                let events: [OprtnEvent] = OperationVM.getEventsOfOperation(oper: oper)
                events.forEach{ event in
                    if event.confirmed == false {
                        moc.delete(event)
                    }
                }
                try? moc.save()
            },
            .cancel(Text("Zrušit"))
        ])
    }
    
    /// Present alert on complete operation request
    /// - Returns: ActionSheet object
    private func completeAlert() -> ActionSheet {
        return ActionSheet(title: Text("Ukončení operace"), message: Text("Chystáte se ukončit operaci. Tato akce je nevratná."), buttons: [
            .default(Text("Ukončit")) {
                if let operation = oper {
                    operation.status = OperationStatus.completed.rawValue
                    try? moc.save()
                }
            },
            .cancel(Text("Zrušit"))
        ])
    }
    
    /// Present alert on delete operation request
    /// - Returns: Alert object
    private func deleteAlert() -> Alert {
        return Alert(
            title: Text("Smazat záznam operace"),
            message: Text("Tato operace je nenávratná"),
            primaryButton: .default(Text("Zrušit"), action: {}),
            secondaryButton: .destructive(Text("Smazat"), action: {
                //Delete Operation
                if let operation = oper {
                    moc.delete(operation)
                    components.operationDetail = nil
                    self.presentationMode.wrappedValue.dismiss()
                }
                try? moc.save()
            })
        )
    }
    
    /// Mark all stages as complete
    private func markAllButton() -> some View {
        return Button(action: {
            let events: [OprtnEvent] = OperationVM.getEventsOfOperation(oper: oper)
            events.forEach{ event in
                withAnimation{
                    event.confirmed = true
                }
            }
            oper?.objectWillChange.send() //Update the view
        }, label: {
            HStack{
                Spacer()
                Text("Potvrdit vše")
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundColor(Color("Typography"))
                    .padding(10)
                    .background(Color("ContentBackground").cornerRadius(10).shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3))
                    .padding(.horizontal, 10)

            }
        })
    }
}






