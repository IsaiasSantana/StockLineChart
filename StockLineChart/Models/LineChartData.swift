//
//  LineChartData.swift
//  StockLineChart
//
//  Created by Isaías Santana on 01/02/24.
//

import Foundation

struct LineChartData {
    let chartState: LineChartState
    let entries: [LineEntry]
    let scaleX: XAxisRange
    let scaleY: YAxisRange
}

struct ChartData {
    let lineData: LineChartData
    let candleData: [CandleEntry]
    let barData: [BarEntry]
}
