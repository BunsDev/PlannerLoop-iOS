//
//
// AddedOperations.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI
import CoreData

struct NewOperations: View {
    @State var sortKey: ListSortingKey = ListSortingKey.index
    var predicate = NSPredicate(format: "%@ == status", argumentArray:[OperationStatus.toBeScheduled.rawValue])
    
    @EnvironmentObject var components: ComponentsVM
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @State var errorInfo: ToastInfo = ToastInfo()
    @State var alertToast = AlertToast(type: .regular, title: "")

    @State var specifyTimeZero: Bool = false
    @State var timeZero: Date = Date()
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack {
                //Navigation Bar
                NavigationHeader(text: "Operace k rozvrhnutí")
                    .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                Spacer()
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 10){
                        TimeZeroPicker(activated: $specifyTimeZero, date: $timeZero)
                        DynamicRequest(sortKey: sortKey.rawValue,ascending: true, emptyListString: "Operace k rozvrhnutí nenalezeny", predicate: predicate, grid: true){ (object: Oprtn) in
                            NewOperationCell(operation: object)
                        }
                        Color(.clear) //ScrollView Bottom Padding for tabbar
                            .padding(.bottom, 60)
                    }
                }
            }
            HStack{
                //Schedule operations
                Button(action:{
                    scheduleOperations(timeZero: timeZero, specifyTimeZero: specifyTimeZero)
                } , label: {
                    SimpleButton(text: "Rozvrhnout", color: "Accent", widthMultiplier: 2, height: 40, style: .caption)
                })
                //New operation
                NavigationLink(
                    destination: OperationForm(),
                    label: {SimpleButton(text: "Přidat úlohu", color: "Background", widthMultiplier: 2, height: 40, style: .caption)}
                )
            }
            .padding(5)
            .background(Color("ContentBackground").shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3).cornerRadius(10))
            .padding(.bottom,15)
        }
        .toast(isPresenting: $errorInfo.show, duration: 2, tapToDismiss: true){ alertToast }
        .background(Color("Background").ignoresSafeArea())
        .hiddenNavigationBarStyle()
        .onAppear{components.hideTabBar()}
    }
    
    /// Send command for query to schedule new operations
    private func scheduleOperations(timeZero: Date, specifyTimeZero: Bool) {
        ApiVM.shared.submitTasks(timeZero: timeZero, specifyTimeZero: specifyTimeZero) { (result: Result<Void, ErrorDescription>) in
            switch result {
                case .success():
                    alertToast = AlertToast(displayMode: .alert, type: .complete(Color("Accent")), title: "Rozvrhnuto")
                    errorInfo.show = true
                case .failure(let error):
                    errorInfo.text = error.errorDescription
                    alertToast = AlertToast(displayMode: .alert, type: .error(Color("Danger")), title: "Chyba", subTitle: errorInfo.text)
                    errorInfo.show = true
            }
        }
    }
    
    /// Get background for table on regular width devices
    private func getBackground() -> some View {
        return Group {
            if horizontalSizeClass == .regular {
                Color("ContentBackground")
                            .cornerRadius(10)
                            .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
            } else {
                EmptyView()
            }
        }
    }
    
    /// Get header for the table on regular width devices
    /// - Parameter width: width of device screen
    private func getHeader(width: CGFloat) -> some View {
        return Group {
            if horizontalSizeClass == .regular {
                TableHeader(columnHeaders: ["Název","Zdroj","Priorita","Příprava","Iterace","Deadline",], width: width )
            } else {
                EmptyView()
            }
        }
    }
    
}

struct NewOperations_Previews: PreviewProvider {
    static var previews: some View {
        NewOperations()
    }
}


