//
//  BarEntry.swift
//  StockLineChart
//
//  Created by Isaías Santana on 07/02/24.
//

import Foundation

struct BarEntry: Identifiable {
    let id = UUID().uuidString

    let x: Double
    let y: Double
}
