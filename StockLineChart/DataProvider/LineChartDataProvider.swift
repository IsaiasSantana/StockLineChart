//
//  LineChartDataProvider.swift
//  StockLineChart
//
//  Created by Isaías Santana on 31/01/24.
//

import Foundation

protocol LineChartDataProviderProtocol {
    func fetchLineChartData() async -> LineChartData
}

final class LineChartDataProvider: LineChartDataProviderProtocol {
    func fetchLineChartData() async -> LineChartData {
       let entries = (0..<20).map {
            LineEntry(xValue: Double($0), yValue: Double(arc4random_uniform(100) + 1))
        }
        
        let minEntry = entries.min(by: { $0.xValue < $1.xValue })
        let maxEntry = entries.max(by: { $1.xValue > $0.xValue })
        let minX = minEntry?.xValue ?? 0
        let maxX = maxEntry?.xValue ?? 0
        let minY = minEntry?.yValue ?? 0
        let maxY = maxEntry?.yValue ?? 0
        
        var chartState: LineChartState
        
        if minY > maxY {
            chartState = .decreasing
        }
        
        if minY < maxY {
            chartState = .increasing
        } else {
            chartState = .neutral
        }
        
        return .init(chartState: chartState, entries: entries, scaleX: .init(minimumX: minX, maximumX: maxX), scaleY: .init(minimumY: minY, maximumY: maxY))
    }
}
