//
//
// Schedule.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct Schedule: View {
    @State var showFullDateBar: Bool = false
    @EnvironmentObject var components: ComponentsVM
    @State private var navLinkActive = false
    @State private var currentScale: CGFloat = 1

    var body: some View {
        
        NavigationView {
            ZStack(alignment: .top){
                NavigationLink(
                    destination: OperationDetail(oper: $components.operationDetail), isActive: $navLinkActive,
                    label: {
                        EmptyView()
                    })
                VStack{
                    Color.clear.frame(height: showFullDateBar ? 180 : 60) //Padding
                    GeometryReader { geo in
                        ScrollView([.vertical,.horizontal]){
                            //List of operations
                            ZStack {
                                ScheduleOperations(date: components.datePicked, scheduleHeight: geo.size.height){ (object: OprtnEvent) in
                                    EventScheduleEntry(event: object, navLinkActive: $navLinkActive)
                                }
                            }
                            .frame(minHeight: geo.size.height)
                            .padding(.leading, 20)
                            .background(GeometryReader { proxy -> Color in
                                DispatchQueue.main.async {
                                    components.scheduleScrollOffset = -proxy.frame(in: .named("scroll")).origin.y
                                }
                                return Color.clear
                            })
                        }
                        .coordinateSpace(name: "scroll")
                    }
                }
                //Day picker
                DayPickerCard(showFull: $showFullDateBar)
            }
            .gesture( MagnificationGesture()
                .onChanged { scale in
                    if scale > currentScale { //Zooming in
                        components.scheduleWidth += 4
                    } else { //Zooming out
                        components.scheduleWidth -= 4
                    }
                    currentScale = scale
                }
                .onEnded{ scale in
                    currentScale = 1
                }
            )
            .background(Color("Background").ignoresSafeArea())
            .hiddenNavigationBarStyle()
            .onAppear{
                if components.showSettingsSheet != true {components.showTabBar()}
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// Function to recognize, if user is zooming in or out
    /// - Parameter nextScale: Next value of zoom
    /// - Returns: Boolean value if user is zooming in
    func isZoomingIn(nextScale: CGFloat) -> Bool {
        if nextScale > currentScale {
            return true
        }
        return false
    }
}

struct Schedule_Previews: PreviewProvider {
    static var previews: some View {
        Schedule()
    }
}

struct ScheduleBackground: View {
    let height: CGFloat
    var body: some View {
        HStack(spacing: 0){
            ForEach(0..<24) { i in
                ScheduleTimeColumn(text: "\(i):00", height: height)
            }
        }
    }
}

