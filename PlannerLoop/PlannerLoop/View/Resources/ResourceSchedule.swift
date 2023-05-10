//
//
// ResourceSchedule.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct ResourceSchedule: View {
    @State var sortKey: ListSortingKey = .start
    @State var ascending: Bool = true
    
    @ObservedObject var res: Resource
    @EnvironmentObject var components: ComponentsVM
    @State private var navLinkActive = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        VStack(spacing: 5){
            //Navbar
            HStack{
                NavigationHeader(text: ResourceVM.shared.getResName(resID: res.identifier) ?? "Neznámý zdroj")
                NavigationLink(
                    destination: EditResourceDestination(res: res),
                    label: {
                        ButtonImageLabel(image: "slider.horizontal.3",  bgColor: "Accent", padding: 15, size: 20)
                    }
                )
            }
            .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
            .padding(.horizontal)
            .padding(.vertical, 5)
            //Resource schedule
            GeometryReader { size in
                ScrollView(.vertical, showsIndicators: false) {
                    //Sort menu
                    SortMenu(selectedSortKey: $sortKey, selectedCategory: .constant(.ongoing), ascending: $ascending)
                        LazyVStack(spacing: 5, pinnedViews: [.sectionHeaders]){
                            Section(header: getHeader(width: size.size.width - 20)){
                                DynamicRequest(sortKey: sortKey.rawValue,ascending: ascending, emptyListString: "Operace zdroje nenalezeny", predicate: NSPredicate(format: "%@ == machineID", argumentArray:[res.identifier ?? ""])){ (object: Oprtn) in
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
                    //Detail nav link
                    NavigationLink(
                        destination: OperationDetail(oper: $components.operationDetail), isActive: $navLinkActive,
                        label: {EmptyView()}) //ScrollView Bottom Padding for tabbar
                }
            }
            
            Spacer()
        }
        .background(Color("Background").ignoresSafeArea())
        .hiddenNavigationBarStyle()
        .onAppear{
            if components.showSettingsSheet != true {
                components.showTabBar()
            }
        }
    }
    
    /// Return background for table
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
    
    /// Header of table on regular width devices
    /// - Parameter width: Width of screen
    private func getHeader(width: CGFloat) -> some View {
        return Group {
            if horizontalSizeClass == .regular {
                TableHeader(columnHeaders: ["Název", "Začátek", "Konec", "Zdroj"], width: width)
            } else {
                EmptyView()
            }
        }
    }
}




