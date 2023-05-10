//
//
// OperationProgressBar.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct OperationProgressBar: View {
    @ObservedObject var operation: Oprtn
    var body: some View {
        GeometryReader { geometry in
                HStack(spacing: 5) {
                    ForEach(0..<Int(operation.iterations)+1) { i in
                        Rectangle()
                            .frame(width: getWidthOfStage(totalWidth: geometry.size.width, stageIndex: i, numberOfIterations: operation.iterations))
                            .foregroundColor(Color(getStageColor(stageIndex: i)))
                    }
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: geometry.size.width)
                .frame(height: 10)
        }
        .cornerRadius(5)
    }
    
    /// Get width of single stage in operation progress bar
    /// - Parameters:
    ///   - totalWidth: Width of the progress bar
    ///   - stageIndex: index of stage to get width for
    ///   - numberOfIterations: how much iterations stage contains
    /// - Returns: width of stage bar
    private func getWidthOfStage(totalWidth: CGFloat, stageIndex: Int, numberOfIterations: Int16) -> CGFloat{
        let usableWidth = totalWidth - CGFloat(numberOfIterations * 5)
        let oneSecondWidth = usableWidth/CGFloat(OperationVM.shared.getTotalOperationDurationInSeconds(operation: operation))
        var width: CGFloat = 0
        if stageIndex == 0 {
            width = oneSecondWidth * CGFloat(operation.instTime)
        } else {
            width = oneSecondWidth * CGFloat(operation.iterDuration)
        }
        return width < 1 ? 1 : width
    }
    
    /// Get color of single stage in operation progress bar
    /// - Parameter stageIndex: index of stage to get width forsss
    /// - Returns: color of stage bar
    private func getStageColor(stageIndex: Int) -> String{
        if stageIndex == 0 { //Installation Stage
            if OperationVM.getSecondsPassed(operation: operation) > operation.instTime { //Installation complete
                if operation.status == OperationStatus.completed.rawValue {
                    return "AccentHigh"
                }
                return "Accent"
            }
        } else {
            if OperationVM.getIterationsCompleted(operation: operation) >= stageIndex {
                if operation.status == OperationStatus.completed.rawValue {
                    return "AccentHigh"
                }
                return "Accent"
            }
        }
        if OperationVM.shared.stageEnded(operation: operation, stageIndex: stageIndex) {
            return "AccentLow"
        }
        return "Disabled"
    }
}
