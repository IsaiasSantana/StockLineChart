//
//  LineChartOverlay.swift
//  StockLineChart
//
//  Created by Isaías Santana on 01/02/24.
//

import Foundation
import SwiftUI
import Charts

struct LineChartOverlay: View {
    private let chartProxy: ChartProxy
    private let onFingersPressed: (FingersPosition) -> Void
    @State private var fingersPosition = FingersPosition()

    init(chartProxy: ChartProxy, onFingersPressed: @escaping (FingersPosition) -> Void, fingersPosition: FingersPosition = FingersPosition()) {
        self.chartProxy = chartProxy
        self.onFingersPressed = onFingersPressed
        self.fingersPosition = fingersPosition
    }

    var body: some View {
        GeometryReader { geometryProxy in
            Rectangle().fill(.clear).overlay {
                TouchView { fingersPosition in
                    var mappedPosition = FingersPosition()
                    
                    if let firstFinger = fingersPosition.firstFinger {
                        mappedPosition.firstFinger = geometryProxy.location(from: chartProxy, dragLocation: firstFinger)
                    }
                    
                    if let secondFinger = fingersPosition.secondFinger {
                        mappedPosition.secondFinger = geometryProxy.location(from: chartProxy, dragLocation: secondFinger)
                    }
                    
                    onFingersPressed(mappedPosition)
                }
            }
        }
    }
    
    private func handleFirstFinger(at location: CGPoint) {
        fingersPosition.firstFinger = location
        onFingersPressed(fingersPosition)
    }
    
    private func handleSecondFinger(at location: CGPoint) {
        fingersPosition.secondFinger = location
        onFingersPressed(fingersPosition)
    }
    
    private func didReleasedFinger() {
        onFingersPressed(fingersPosition)
    }
}

extension GeometryProxy {
    func location(from chartProxy: ChartProxy, dragLocation: CGPoint) -> CGPoint? {
        guard let plotFrame = chartProxy.plotFrame else {
            return nil
        }
        
        let origin = self[plotFrame].origin
        let point = CGPoint(x: dragLocation.x - origin.x, y: dragLocation.y - origin.y)
        
        guard let value: Double = chartProxy.value(atX: round(dragLocation.x - origin.x)) else {
            return nil
        }
        
        return .init(x: value, y: point.y)
    }
}
