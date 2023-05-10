//
//
// EventScheduleEntry.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct EventScheduleEntry: View {
    @EnvironmentObject var components: ComponentsVM
    let event: OprtnEvent
    @Binding var navLinkActive: Bool
    
    var body: some View {
        Button {
            components.operationDetail = event.operation
            navLinkActive = true
        } label: {
            HStack(spacing: 10){
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 4)
                    .frame(minHeight: 30)
                    .padding(.vertical, 5)
                    .foregroundColor(isActive() ? Color("Accent") : Color("TypographyLow"))
                VStack(){
                    if let startEndLabel = getStartEndLabel() {
                        Text(startEndLabel)
                            .fontWeight(.semibold)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("TypographyMedium"))
                    }
                    Text(event.operation?.name ?? "Nepojmenováno")
                        .fontWeight(.semibold)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color("Typography"))
                    if let resName = ResourceVM.shared.getResName(resID: event.operation?.machineID) {
                        Text(resName)
                            .fontWeight(.semibold)
                            .font(.callout)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("TypographyMedium"))
                    }
                }
            }
            .padding(5)
            .padding(.horizontal, 5)
            .frame(width: calculateWidth())
            .background(Color(event.confirmed ? "AccentLow" : "ContentBackground").cornerRadius(10).shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3))
        }
        .offset(x:calculateOffset())
        .frame(minWidth: 50, maxHeight: 100)
    }
    private func isActive() -> Bool{
        return false
    }
    
    private func getStartEndLabel(hoursOnly: Bool = true) -> String?{
        //Time label start:end
        let dateFormatter = DateFormatter()
        if let start = event.start, let end = event.end{
            if Calendar.areTheSameDay(first: end, second: start) && hoursOnly {
                dateFormatter.dateFormat = "HH:mm"
            }
            else {
                //Different days, contain number of day also
                dateFormatter.dateFormat = "dd.MM HH:mm"
            }
            return "\(dateFormatter.string(from: start)) - \(dateFormatter.string(from: end))"
        }
        return nil
    }
    
    private func calculateOffset() -> CGFloat{
        //Offset from the start of the schedule
        if let start = event.start {
            if Calendar.areTheSameDay(first: components.datePicked, second: start){
                //If operation starts selected day, calculate offset
                let hour = Double(Calendar.current.component(.hour, from: start))
                let minutes = Double(Calendar.current.component(.minute, from: start))
                return CGFloat(Double(components.scheduleWidth)*hour+(minutes/60*Double(components.scheduleWidth)))
            }
        }
        return 0
    }
    
    private func calculateWidth() -> CGFloat{
        //Get offset, if end is selected day, calculate end position minus offset else width of schedule minus offset
        let offset = calculateOffset()
        let maxWidth = 24 * components.scheduleWidth - offset
        if let end = event.end{
            if Calendar.areTheSameDay(first: components.datePicked, second: end) {
                let hours = Double(Calendar.current.component(.hour, from: end))
                let minutes = Double(Calendar.current.component(.minute, from: end))
                let minutesInDayOfEnd = 60*hours+minutes
                let endInFraction = minutesInDayOfEnd/1440 //dividing supposed end by total number of minutes in a day
                let widthWithoutOffset = endInFraction * 24 * Double(components.scheduleWidth)
                let actualWidth = max(30,CGFloat(widthWithoutOffset) - offset)
                
                return actualWidth
            }
        }
        return maxWidth
    }
}
