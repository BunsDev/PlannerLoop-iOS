//
//
// OperationsList.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct OperationsList: View {
    @Binding var selectedCategory: ListCategory
    @Binding var sortKey: ListSortingKey
    @Binding var ascending: Bool

    var predicate: NSPredicate
    
    @EnvironmentObject var components: ComponentsVM
    @State private var navLinkActive = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    
    init(category: Binding<ListCategory>, sortKey: Binding<ListSortingKey>, ascending: Binding<Bool>){
        self._selectedCategory = category
        self._sortKey = sortKey
        self._ascending = ascending

        //Category predicate, need to furthermore filter ongoing and toconfirm operations after retrieving fetchresult based on operation end
        if category.wrappedValue == ListCategory.ongoing {
            predicate = NSPredicate(format: "status == %@", argumentArray:[OperationStatus.scheduled.rawValue]) //Operation.end
        } else if category.wrappedValue == ListCategory.toConfirm {
            predicate = NSPredicate(format: "status == %@", argumentArray:[OperationStatus.scheduled.rawValue]) //Operation.endOperationStatus.scheduled.rawValue])
            //Operation.end
        } else if category.wrappedValue == ListCategory.completed {
            predicate = NSPredicate(format: "%@ == status || %@ == status ", argumentArray:[OperationStatus.completed.rawValue, OperationStatus.failed.rawValue])
        } else {
            //Scheduling
            predicate = NSPredicate(format: "%@ == status", argumentArray:[OperationStatus.scheduling.rawValue])
        }
    }
    
    var body: some View {
        GeometryReader { size in
            ScrollView(.vertical, showsIndicators: false) {
                //Sort menu
                SortMenu(selectedSortKey: $sortKey, selectedCategory: $selectedCategory, ascending: $ascending)
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]){
                        //Operation List
                        Section(header: getHeader(width: size.size.width - 20)){
                            OprtnRequest(sortKey: sortKey,ascending: ascending, category: selectedCategory, emptyListString: "Operace nenalezeny", predicate: predicate){ (object: Oprtn) in
                                Button {
                                    components.operationDetail = object
                                    navLinkActive = true
                                } label: {
                                    if horizontalSizeClass == .regular { OperationTableRow(operation: object, width: size.size.width - 20) }
                                    else {OperationCell(operation: object)}
                                }
                            }
                        }
                    }
                    .padding(.bottom, horizontalSizeClass == .regular  ? 0 : 10)
                    .cornerRadius(10)
                    .background(getBackground())
                    .padding(.horizontal, horizontalSizeClass == .regular  ? 10 : 0)
                    Color.clear.frame(height: 75)
                NavigationLink(
                    destination: OperationDetail(oper: $components.operationDetail), isActive: $navLinkActive,
                    label: {EmptyView()}) //ScrollView Bottom Padding for tabbar
            }
        }
    }
    
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
    
    private func getHeader(width: CGFloat) -> some View {
        return Group {
            if horizontalSizeClass == .regular {
                TableHeader(columnHeaders: ["Název", "Začátek", "Konec", "Zdroj"], width: width )
            } else {
                EmptyView()
            }
        }
    }
}

struct OperationsList_Previews: PreviewProvider {
    static var previews: some View {
        OperationsList(category: .constant(.ongoing), sortKey: .constant(.name), ascending: .constant(true))
    }
}
