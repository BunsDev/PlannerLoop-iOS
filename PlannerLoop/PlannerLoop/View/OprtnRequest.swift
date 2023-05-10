//
//
// OprtnRequest.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	
import SwiftUI
import CoreData

//Fetch request via array that allows sorting via one to many property that nssortdescriptor doesnt
struct OprtnRequest<Content: View>: View {
    var operations: Array<Oprtn>
    //Content to show with fetched objects
    let content: (Oprtn) -> Content
    let emptyListString: String
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var components: ComponentsVM

    var body: some View {
        Group {
            if operations.isEmpty {
                //No objects returned
                Text(emptyListString)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(10)
                    .foregroundColor(Color("TypographyMedium"))
            } else {
                ForEach(operations, id: \.self) { operation in
                    self.content(operation)
                }
            }
        }
    }
    
    
    init(sortKey: ListSortingKey, ascending: Bool, category: ListCategory, emptyListString: String, predicate: NSPredicate? = nil, grid: Bool = false, @ViewBuilder content: @escaping (Oprtn) -> Content) {
        let context = PersistenceController.shared.container.viewContext
        //Create fetch request
        let fetchRequest: NSFetchRequest<Oprtn>
        fetchRequest = Oprtn.fetchRequest()
        fetchRequest.predicate = predicate
        if sortKey != .start &&  sortKey != .end {
            let sorting = NSSortDescriptor(key: sortKey.rawValue, ascending: ascending)
            fetchRequest.sortDescriptors = [sorting]
        }
        do {
            let ops = try context.fetch(fetchRequest)
            //Filtering ongoing and toconfirm operations
            let opsFiltered = ops.filter { operation in
                if category == .ongoing {
                    return OperationVM.getOperationEnd(oper: operation) ?? Date() > Date()
                } else if category == .toConfirm {
                    return OperationVM.getOperationEnd(oper: operation) ?? Date() <= Date()
                } else {
                    return true
                }
            }
            
            if sortKey == .start {
                //Sorting by the end date of operation
                if ascending {
                    operations = opsFiltered.sorted(by: { OperationVM.getOperationStart(oper: $0) ?? Date() <  OperationVM.getOperationStart(oper: $1) ?? Date() } )
                } else {
                    operations = opsFiltered.sorted(by: { OperationVM.getOperationStart(oper: $0) ?? Date() > OperationVM.getOperationStart(oper: $1) ?? Date() } )
                }
            } else if sortKey == .end {
                //Sorting by the end date of operation
                if ascending {
                    operations = opsFiltered.sorted(by: { OperationVM.getOperationEnd(oper: $0) ?? Date() <  OperationVM.getOperationEnd(oper: $1) ?? Date() })
                } else {
                    operations = opsFiltered.sorted(by: { OperationVM.getOperationEnd(oper: $0) ?? Date() >  OperationVM.getOperationEnd(oper: $1) ?? Date() })
                }
            } else {
                operations = opsFiltered
            }
        } catch {
            operations = []
        }

        self.content = content
        self.emptyListString = emptyListString
    }
}
