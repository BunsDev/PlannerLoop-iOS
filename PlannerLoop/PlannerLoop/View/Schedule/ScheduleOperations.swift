//
//
// ScheduleOperations.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct ScheduleOperations<Content: View>: View {
    
    @FetchRequest var fetchRequest: FetchedResults<OprtnEvent>
    @EnvironmentObject var components: ComponentsVM
    @State var dateError: Bool = false
    var scheduleHeight: CGFloat
    let content: (OprtnEvent) -> Content

    var body: some View {
        Group {
            if fetchRequest.isEmpty || dateError {
                //No objects returned or error while deriving next date
                Text("Žádné operace rozvrhnuty na tento den")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(10)
                    .foregroundColor(Color("TypographyMedium"))
                    .padding(.leading, -20)
            } else {
                GeometryReader { proxy in
                    ScheduleBackground(height: proxy.size.height)
                    if Calendar.current.isDate(components.datePicked, equalTo: Date(), toGranularity: .day) {
                        TimeNeedle(height: proxy.size.height)
                    }
                }
                LazyVStack(alignment: .leading,spacing: 20){
                    ForEach(fetchRequest, id: \.self) { object in
                        self.content(object)
                        LineWidth()
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [15]))
                            .foregroundColor(Color("TypographyLow"))
                            .frame(width: components.scheduleWidth*24)
                    }
                    Spacer()
                    Color.clear.padding(.bottom, getSafeArea().bottom == 0 ?  70 : getSafeArea().bottom )
                }
                .padding(.top, 60)
                .frame(width: 24*components.scheduleWidth+50) //24 columns of width scheduleHourWidth + padding of background
            }
        }

    }
    
    init(date: Date, scheduleHeight: CGFloat, @ViewBuilder content: @escaping (OprtnEvent) -> Content) {
        //Date filtering tasks, creating predicate
        self.content = content
        self.scheduleHeight = scheduleHeight
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: date)
        if let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom) {
            let betweenDatePredicate = NSPredicate(format: "start >= %@ AND start < %@", argumentArray:[dateFrom,dateTo])
            let startEarlyPredicate = NSPredicate(format: "end >= %@ AND end < %@", argumentArray:[dateFrom,dateTo])
            let allDayPredicate = NSPredicate(format: "start < %@ AND end > %@", argumentArray:[dateFrom,dateTo])
            let orPredicates = NSCompoundPredicate(orPredicateWithSubpredicates: [betweenDatePredicate, startEarlyPredicate, allDayPredicate])
            //Operation start is between day start and day end OR starts earlier day and ends on selected day OR starts earlier day and ends on next days
            //let statusPredicate = NSPredicate(format: "%@ == status", argumentArray:[OperationStatus.scheduled.rawValue])
            //let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [orPredicates, statusPredicate])
            _fetchRequest = FetchRequest<OprtnEvent>(sortDescriptors: [NSSortDescriptor(keyPath: \OprtnEvent.start, ascending: true),NSSortDescriptor(keyPath: \OprtnEvent.end, ascending: true)], predicate: orPredicates)
        } else {
            //Error while deriving next date from selected one, throw error
            _fetchRequest = FetchRequest<OprtnEvent>(sortDescriptors: [])
            dateError = true
        }
    }
}

