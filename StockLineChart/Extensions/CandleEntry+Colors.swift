//
//  CandleEntry+Colors.swift
//  StockLineChart
//
//  Created by Isaías Santana on 07/02/24.
//

import Foundation
import SwiftUI

extension CandleEntry {
    var color: Color {
        if isNeutral {
            return .neutralColor
        }
        
        if isIncreasing {
            return .increasingColor
        }
        
        return .decreasingColor
    }
}
