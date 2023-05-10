//
//
// ScheduleTimeColumn.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct ScheduleTimeColumn: View {
    @EnvironmentObject var components: ComponentsVM
    let text: String
    let height: CGFloat
    //Hour column in schedule
    var body: some View {
        HStack(alignment: .top, spacing: 0){
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)){
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [15]))
                    .foregroundColor(Color("TypographyLow"))
                    .frame(height: height)
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .frame(height: 45)
            }
            .frame(width: 2)
            Text(text)
                .padding(.leading, 5)
            Spacer()
        }
        .offset(y: components.scheduleScrollOffset)
        .foregroundColor(Color("TypographyMedium"))
        .frame(width: components.scheduleWidth)
    }
}

struct ScheduleTimeColumn_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleTimeColumn(text: "10:00", height: 500)
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
    }
}

struct LineWidth: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
