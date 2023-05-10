//
//
// BackgroudBlur.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

//Background blur
//.background(Blur(style: .systemUltraThinMaterial).ignoresSafeArea())

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    ///Construct blur
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    ///Update view
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
