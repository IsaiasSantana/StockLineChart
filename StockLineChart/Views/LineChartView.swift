//
//  LineChartView.swift
//  StockLineChart
//
//  Created by Isaías Santana on 31/01/24.
//

import Foundation
import SwiftUI
import Charts

struct LineChartView: View {
    @State private var fingersPosition = FingersPosition()
    @State private var subChartState: LineChartState?

    private var chartData: LineChartData

    init(chartData: LineChartData) {
        self.chartData = chartData
    }
    
    var body: some View {
        Chart {
            drawLines()
            
            if let firstIndex = fingersPosition.firstFinger?.x.asInt {
                drawRuleMark(at: firstIndex)
            }
            
            if let secondIndex = fingersPosition.secondFinger?.x.asInt {
                drawRuleMark(at: secondIndex)
            }
        }
        .chartXScale(domain: (chartData.scaleX.minimumX...chartData.scaleX.maximumX))
        .chartOverlay { chartProxy in
            LineChartOverlay(chartProxy: chartProxy) { fingersPosition in
                handleFingersPosition(fingersPosition)
            }
        }
    }

    private func drawLines() -> some ChartContent {
            ForEach(chartData.entries) { entry in
                drawChartMarkWithEntry(entry, chartState: fingersPosition.atLeastOneFingerPressed ? .neutral : chartData.chartState)
                    .opacity(subChartState == nil ? 1 : 0.5)
                
                drawAreaMarkWithEntry(entry: entry, chartState: fingersPosition.atLeastOneFingerPressed ? .neutral : chartData.chartState)
                    .opacity(subChartState == nil ? 0.3 : 0.1)
                    
                if hasSubChart(for: entry), let subChartState {
                    drawSubChartMarkWithEntry(entry, chartState: subChartState)
                    drawSubChartAreaMarkWithEntry(entry: entry, chartState: subChartState)
                }
            }
    }
    
    private func hasSubChart(for entry: LineEntry) -> Bool {
        guard subChartState != nil else {
            return false
        }
        
        guard let minMaxOnXAxis = fingersPosition.minMaxOnXAxis else {
            return false
        }
        
        let startIndex = minMaxOnXAxis.min.x.asInt
        let endIndex = minMaxOnXAxis.max.x.asInt
        
        guard chartData.entries.indices.contains(startIndex), endIndex >= 0, endIndex <  chartData.entries.count else {
            return false
        }
        
        return entry.xValue >= chartData.entries[startIndex].xValue  && entry.xValue <= chartData.entries[endIndex].xValue
    }
    
    private func drawChartMarkWithEntry(_ entry: LineEntry, chartState: LineChartState) -> some ChartContent {
        LineMark(
            x: .value("Time", entry.xValue),
            y: .value("Value",entry.yValue),
            series: .value("one", "one")
        )
        .lineStyle(.init(lineWidth: 2))
        .interpolationMethod(.linear)
        .foregroundStyle(chartState.color)
    }
    
    private func drawAreaMarkWithEntry(entry: LineEntry, chartState: LineChartState) -> some ChartContent {
        AreaMark(
            x: .value("Time", entry.xValue),
            yStart: .value("Min", 0),
            yEnd: .value("Max",entry.yValue),
            series: .value("one", "one")
        )
        .foregroundStyle(
            LinearGradient(gradient: Gradient(colors: [chartState.color, .clear]), startPoint: .top, endPoint: .bottom)
        )
    }
    
    private func drawSubChartMarkWithEntry(_ entry: LineEntry, chartState: LineChartState) -> some ChartContent {
        LineMark(
            x: .value("Time", entry.xValue),
            y: .value("Value",entry.yValue),
            series: .value("two", "two")
        )
        .interpolationMethod(.linear)
        .lineStyle(.init(lineWidth: 2))
        .foregroundStyle(chartState.color)
    }
    
    private func drawSubChartAreaMarkWithEntry(entry: LineEntry, chartState: LineChartState) -> some ChartContent {
        AreaMark(
            x: .value("subChartTime", entry.xValue),
            yStart: .value("subChartMin", 0),
            yEnd: .value("subChartMax",entry.yValue),
            series: .value("two", "two")
        )
        .foregroundStyle(
            LinearGradient(gradient: Gradient(colors: [chartState.color, .clear]), startPoint: .top, endPoint: .bottom)
        ).opacity(0.5)
    }
    
    private func drawRuleMark(at index: Int) -> some ChartContent {
        return RuleMark(x: .value("Selected timestamp", index))
            .lineStyle(.init(lineWidth: 2, dash: [10, 10]))
            .foregroundStyle(subChartState?.color ?? .neutralColor)
    }
    
    private func handleFingersPosition(_ fingersPosition: FingersPosition) {
        self.fingersPosition = fingersPosition
        print(fingersPosition)
        handleSubChart(at: fingersPosition)
    }
    
    private func handleSubChart(at fingersPosition: FingersPosition) {
        guard let minMaxOnXAxis = fingersPosition.minMaxOnXAxis else {
            subChartState = nil
            return
        }

        let startIndex = minMaxOnXAxis.min.x.asInt
        let endIndex = minMaxOnXAxis.max.x.asInt
        
        guard chartData.entries.indices.contains(startIndex), endIndex >= 0, endIndex < chartData.entries.count else {
            subChartState = nil
            return
        }
        
        let startEntry = chartData.entries[startIndex]
        let endEntry = chartData.entries[endIndex]
        
        if startEntry.yValue > endEntry.yValue {
            subChartState = .decreasing
            return
        }
        
        if startEntry.yValue < endEntry.yValue {
            subChartState = .increasing
            return
        }
        
        subChartState = .neutral
    }
}

#Preview {
    LineChartView(chartData: .init(chartState: .increasing, entries: [], scaleX: .init(minimumX: 0, maximumX: 0), scaleY: .init(minimumY: 0, maximumY: 0)))
}
