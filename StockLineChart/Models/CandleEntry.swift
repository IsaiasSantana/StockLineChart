//
//  CandleEntry.swift
//  StockLineChart
//
//  Created by Isaías Santana on 07/02/24.
//

import Foundation

struct CandleEntry: Identifiable {
    let id = UUID().uuidString

    let x: Double
    let high: Double
    let low: Double
    let open: Double
    let close: Double

    var isIncreasing: Bool {
        open > close
    }
    
    var isNeutral: Bool {
        open == close
    }
}
