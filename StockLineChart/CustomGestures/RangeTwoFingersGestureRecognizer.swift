//
//  RangeTwoFingersGestureRecognizer.swift
//  StockLineChart
//
//  Created by Isaías Santana on 01/02/24.
//

import Foundation
import SwiftUI

final class RangeTwoFingersGestureRecognizer: UIGestureRecognizer {
    private var touchesForInteractions = Set<UITouch>()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)

        let totalTouches = touchesForInteractions.count + touches.count
        
        switch totalTouches {
        case 1, 2:
            touchesForInteractions = touchesForInteractions.union(touches)
            state = touchesForInteractions.count == 1 ? .began : .changed
            
        default: break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if !touchesForInteractions.intersection(touches).isEmpty {
            state = .changed
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        touchesForInteractions = touchesForInteractions.subtracting(touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        touchesForInteractions = touchesForInteractions.subtracting(touches)
    }
    
    func fingersPosition() -> FingersPosition {
        var position = FingersPosition()

        guard let view else {
            return position
        }

        let locations = touchesForInteractions.map { $0.location(in: view) }
        
        guard !locations.isEmpty else {
            return position
        }
        
        if locations.count == 1 {
            position.firstFinger = locations.first
            return position
        }
        
        if locations.count == 2 {
            position.firstFinger = locations.first
            position.secondFinger = locations.dropFirst().first
        }
        
        return position
    }
}
