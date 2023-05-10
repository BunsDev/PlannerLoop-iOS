//
//
// OperationDetailCell.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct OperationDetailCell: View {
    let headline: String
    var description: String = ""
    var detail: String = ""

    //Cell in operation detail
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                    Text(headline)
                    .font(.subheadline)
                    .foregroundColor(Color("TypographyMedium"))
                if description != "" {
                    Text(description)
                    .font(.caption)
                    .foregroundColor(Color("TypographyMedium"))
                }
            }
            if detail != "" {
                Text(detail)
                .font(.headline)
                .foregroundColor(Color("Typography"))
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(5)
    }
}
