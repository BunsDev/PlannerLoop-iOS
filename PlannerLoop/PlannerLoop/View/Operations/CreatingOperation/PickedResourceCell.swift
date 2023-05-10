//
//
// PickedResourceCell.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI
//Cell for the picked resource
struct PickedResourceCell: View {
    @Binding var picked: Resource?
    var body: some View {
        VStack {
            //Headline
            HStack {
                ZStack {
                    //Resource information
                    if let employee = picked as? Employee {
                        Text("\(employee.name ?? "") \(employee.surname ?? "")")
                            .fontWeight(.semibold)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text(picked?.name ?? "")
                            .fontWeight(.semibold)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(height: 40)
                .padding(.horizontal)
                .background(
                    Color("Accent")
                        .cornerRadius(10)
                        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
                )
                //Clear picked resource
                Button(action: {
                    picked = nil
                }, label: {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                        .rotationEffect(.init(degrees: 45))
                        .clipped()
                        .padding(11)
                        .background(
                            Color("Accent")
                                .cornerRadius(10)
                                .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
                        )
                })
            }
            .foregroundColor(Color("Typography"))
        }

    }
}
