//
//
// DynamicRequest.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI
import CoreData

struct DynamicRequest<T: NSManagedObject, Content: View>: View {
    //Prepare fetch request for generic type T
    @FetchRequest var fetchRequest: FetchedResults<T>
    //Content to show with fetched objects
    let content: (T) -> Content
    let emptyListString: String
    let allowGrid: Bool
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        Group {
            if fetchRequest.isEmpty {
                //No objects returned
                Text(emptyListString)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(10)
                    .foregroundColor(Color("TypographyMedium"))
            } else {
                if allowGrid {
                    //If grid is allowed, show content in grid with two or one column
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: horizontalSizeClass == .compact ? 1 : 2)){
                        ForEach(fetchRequest, id: \.self) { object in
                            self.content(object)
                        }
                    }
                } else {
                    //Standard list
                    ForEach(fetchRequest, id: \.self) { object in
                        self.content(object)
                    }
                }
            }
        }
    }
    
    init(sortKey: String, ascending: Bool, emptyListString: String, predicate: NSPredicate? = nil, grid: Bool = false, @ViewBuilder content: @escaping (T) -> Content) {
        let sortDesc = NSSortDescriptor(key: sortKey, ascending: ascending)
        _fetchRequest = FetchRequest<T>(sortDescriptors: [sortDesc], predicate: predicate)
        self.content = content
        self.emptyListString = emptyListString
        self.allowGrid = grid
    }
    
}
