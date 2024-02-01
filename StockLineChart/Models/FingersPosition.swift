//
//  FingersPosition.swift
//  StockLineChart
//
//  Created by Isaías Santana on 31/01/24.
//

import Foundation

struct FingersPosition {
    var firstFinger: CGPoint?
    var secondFinger: CGPoint? {
        willSet {
            guard firstFinger != nil && newValue?.x != firstFinger?.x else {
                return
            }
        }
    }
    
    var atLeastOneFingerPressed: Bool {
        (firstFinger != nil && secondFinger == nil) || (firstFinger == nil && secondFinger != nil)
    }
    
    var minMaxOnXAxis: (min: CGPoint, max: CGPoint)? {
        guard let min = minOXAxis(), let max = maxOXAxis() else {
            return nil
        }
        return (min: min, max: max)
    }

    private func minOXAxis() -> CGPoint? {
        guard let firstFinger, let secondFinger else {
            return nil
        }

        if firstFinger.x < secondFinger.x {
            return firstFinger
        }

        return secondFinger
    }

    private func maxOXAxis() -> CGPoint? {
        guard let firstFinger, let secondFinger else {
            return nil
        }
        
        if firstFinger.x > secondFinger.x {
            return firstFinger
        }

        return secondFinger
    }
}

extension CGFloat {
    var asInt: Int {
        Int(self)
    }
}
