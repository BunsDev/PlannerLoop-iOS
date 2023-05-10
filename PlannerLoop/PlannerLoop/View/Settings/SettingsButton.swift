//
//
// SettingsButton.swift
// PlannerLoop
// Single button in settings
// Created by Tomáš Tomala
//
	

import SwiftUI

struct SettingsButton: View {
    let image: String
    let headline: String
    var description: String = ""
    var detail: String = ""
    var divider: Bool = true

    var body: some View {
        VStack{
            HStack(spacing: 10) {
                //Button image
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("Typography"))
                    .clipped()
                    .padding(10)
                    .background(Color("ContentBackground"))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("Disabled"), lineWidth: 0.8))
                //Button label
                VStack(alignment: .leading, spacing: 2) {
                        Text(headline)
                        .fontWeight(.semibold)
                        .font(.callout)
                        .foregroundColor(Color("Typography"))
                    if description != "" {
                        Text(description)
                        .fontWeight(.medium)
                        .font(.caption)
                        .foregroundColor(Color("TypographyMedium"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if detail != "" {
                    Text(detail)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Typography"))
                }
            }
            .padding(5)
            if divider {Divider()}
        }

    }
}
