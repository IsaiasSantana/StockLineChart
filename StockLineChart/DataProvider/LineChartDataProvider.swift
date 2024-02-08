//
//  LineChartDataProvider.swift
//  StockLineChart
//
//  Created by Isaías Santana on 31/01/24.
//

import Foundation

protocol LineChartDataProviderProtocol {
    func fetchLineChartData() async -> ChartData
}

final class LineChartDataProvider: LineChartDataProviderProtocol {
    private let totalItems = 20
    
    func fetchLineChartData() async -> ChartData {
        let lineData = generateLineData()
        let barEntries = generateBarEntries()
        let candleEntries = generateCandleEntries()
        
        return .init(lineData: lineData, candleData: candleEntries, barData: barEntries)
    }
    
    private func generateLineData() -> LineChartData {
        let entries = (0..<totalItems).map {
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
    
    private func generateBarEntries() -> [BarEntry] {
        (0..<totalItems).map {
             BarEntry(x: Double($0), y: Double(arc4random_uniform(100) + 1))
         }
    }
    
    private func generateCandleEntries() -> [CandleEntry] {
        (0..<60).map { i in
            let mult: UInt32 = 10 + 1
            let val = Double(arc4random_uniform(40) + mult)
            let high = Double(arc4random_uniform(9) + 8)
            let low = Double(arc4random_uniform(9) + 8)
            let open = Double(arc4random_uniform(6) + 1)
            let close = Double(arc4random_uniform(6) + 1)
            let even = i % 2 == 0
            
            return CandleEntry(x: Double(i),
                               high: val + high,
                               low: val - low,
                               open: even ? val + open : val - open,
                               close: even ? val - close : val + close)
        }
    }
}
