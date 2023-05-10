//
//
// RoundedCorner.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct RoundedCorner: Shape {
    //iOS compatible rounded corners
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


