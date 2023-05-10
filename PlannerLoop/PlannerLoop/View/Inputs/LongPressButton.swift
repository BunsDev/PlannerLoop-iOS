//
//
// LongPressButton.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	
import SwiftUI
import Foundation

struct LongPressButton<Label>: View where Label: View {
    let label: (() -> Label)
    let action: () -> Void
    let longPressAction: () -> Void
    
    @State private var timer: Timer?
    @State var didLongPress = false

    init(action: @escaping () -> Void, longPressAction: @escaping () -> Void, label: @escaping () -> Label) {
        self.label = label
        self.action = action
        self.longPressAction = longPressAction
    }
    //Button with longpress action
    var body: some View {
        Button(action: {
            if(self.didLongPress){
                //End of long press
                self.didLongPress.toggle()
                self.timer?.invalidate()
            } else {
                //Button Tap
                action()
            }
        }, label: { label() })
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
            //Start of long press
            didLongPress = true
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { _ in
                longPressAction()
            })
        })
    }
}


