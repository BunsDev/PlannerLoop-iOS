//
//  SlideOverCard.swift
//  Custom draggable half sheet 
//  Created by Tomáš Tomala
//  Inspired by Michael Shafer @mshafer https://gist.github.com/mshafer/7e05d0a120810a9eb49d3589ce1f6f40
//

import SwiftUI

struct SlideOverCard<Content: View> : View {
    
    @Binding var isPresented:Bool
    var maxHeight:CGFloat
    var maxWidth:CGFloat 
    var content: () -> Content
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @GestureState private var dragState = DragState.inactive
    @EnvironmentObject var components: ComponentsVM
    //Draggable sheet
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
        }
        .onEnded(onDragEnded)
        return Group {
            ZStack {
                if isPresented { //Background
                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Blur(style: .systemUltraThinMaterialDark).ignoresSafeArea())
                        .onTapGesture {
                            self.isPresented = false
                            components.showTabBar()
                        }
                }
                
                VStack{ //Foreground
                    Spacer()
                    ZStack{
                        Color("ContentBackground").ignoresSafeArea()
                            .cornerRadius(40)
                            .frame(maxWidth: .infinity, maxHeight: calculateHeight())
                        VStack(spacing: 10){
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 40, height: 4)
                                .padding(.vertical, 5)
                            self.content()
                        }
                        .padding(5)
                        .padding(.bottom, 30)
                        .frame(maxWidth: .infinity, maxHeight: calculateHeight())
                        .clipped()
                    }
                    .padding(.horizontal, 5)
                    .opacity(isPresented ? 1 : 0)
                    .offset(y: isPresented ? ((self.dragState.isDragging && dragState.translation.height >= 1) ? dragState.translation.height : -5) : calculateHeight())
                    .gesture(drag)
                }
                .frame(maxWidth: calculateWidth())

            }
            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    /// Action to start when dragging the sheet ended, hide the sheet or stay visible
    /// - Parameter drag: Drag change value
    private func onDragEnded(drag: DragGesture.Value) {
        let dragThreshold = calculateHeight() * (2/4)
        if drag.predictedEndTranslation.height > dragThreshold || drag.translation.height > dragThreshold{
            self.isPresented = false
            components.showTabBar()
        }
    }
    
    /// Get height of partial sheet
    /// - Returns: ideal height of sheet
    private func calculateHeight() -> CGFloat {
        if horizontalSizeClass != .regular {
            return min( 560, maxHeight - 40)
        } else  { 
            return min( 360, maxHeight - 20)
        }
    }
    
    /// Get width of partial sheet
    /// - Returns: ideal width of sheet
    private func calculateWidth() -> CGFloat {
        if horizontalSizeClass != .regular {
            return min( 400, maxWidth - 20)
        } else  {
            return min( 700, maxWidth - 20)
        }
    }
}

