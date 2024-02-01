//
//  LineEntry.swift
//  StockLineChart
//
//  Created by Isaías Santana on 31/01/24.
//

import Foundation

struct LineEntry: Identifiable {
    let id = UUID().uuidString
    let xValue: Double
    let yValue: Double
}
