//
//
// TableHeader.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct TableHeader: View {
    //Table header with multiple columns
    let columnHeaders: [String]
    let width: CGFloat
    var body: some View {
            HStack(spacing: 0){
                ForEach(0..<Int(columnHeaders.count)) { i in
                    TableCell(title: columnHeaders[i], width: colWidth(tableWidth: width), showDivider: i != (columnHeaders.count-1), isHeader: true)
                }
            }
            .background(Color("ContentBackground")
                            .cornerRadius(10)
                            .ignoresSafeArea()
                            .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
            )
    }
    
    private func colWidth(tableWidth: CGFloat) -> CGFloat {
        return max(tableWidth / CGFloat(columnHeaders.count), 0)
    }
}

struct OperationsTableHeader_Previews: PreviewProvider {
    static var previews: some View {
        TableHeader(columnHeaders: ["Header 1", "Header 2", "Header 3"], width: 300)
    }
}





