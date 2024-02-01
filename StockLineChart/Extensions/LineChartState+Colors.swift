//
//  LineChartState+Colors.swift
//  StockLineChart
//
//  Created by Isaías Santana on 01/02/24.
//

import Foundation
import SwiftUI

extension LineChartState {
    var color: Color {
        switch self {
        case .increasing:
            return .increasingColor
        case .decreasing:
            return .decreasingColor
        case .neutral:
            return .neutralColor
        }
    }
}
