//
//  LineChartView.swift
//  StockLineChart
//
//  Created by Isaías Santana on 31/01/24.
//

import Foundation
import SwiftUI
import Charts

private enum ChartType {
    case bar
    case candle
    case line
    
    var chartName: String {
        switch self {
        case .bar:
            return "Bar"
        
        case .candle:
            return "Candle"
            
        case .line:
            return "Line"
        }
    }
}

struct LineChartView: View {
    @State private var fingersPosition = FingersPosition()
    @State private var subChartState: LineChartState?
    
    private var chartTypes: [ChartType] = [.line, .bar, .candle]
    @State private var selectedChart = ChartType.line

    private var chartData: ChartData

    init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    var body: some View {
        VStack {
            Text("Select the chart type")

            Picker("Chart type", selection: $selectedChart) {
                ForEach(chartTypes, id: \.self) { chartType in
                    Text(chartType.chartName)
                }
            }.pickerStyle(.segmented)
            
            switch selectedChart {
            case .bar:
                Chart {
                    ForEach(chartData.barData) { entry in
                        BarMark(x: .value("Time", entry.x), y: .value("Value", entry.y))
                    }
                }

           
            case .candle:
                Chart {
                    ForEach(chartData.candleData) { entry in
                        Plot {
                            BarMark(
                                x: .value("x", entry.x),
                                yStart: .value("open", entry.open),
                                yEnd: .value("close", entry.close),
                                width: 4
                            ).foregroundStyle(entry.color)
                            
                            BarMark(
                                x: .value("x", entry.x),
                                yStart: .value("high", entry.high),
                                yEnd: .value("low", entry.low),
                                width: 1
                            ).foregroundStyle(entry.color)
                        }
                    }
                }
                
            case .line:
                Chart {
                    drawLines()
                    
                    if let firstIndex = fingersPosition.firstFinger?.x.asInt {
                        drawRuleMark(at: firstIndex)
                    }
                    
                    if let secondIndex = fingersPosition.secondFinger?.x.asInt {
                        drawRuleMark(at: secondIndex)
                    }
                }
                .chartXScale(domain: (chartData.lineData.scaleX.minimumX...chartData.lineData.scaleX.maximumX))
                .chartOverlay { chartProxy in
                    LineChartOverlay(chartProxy: chartProxy) { fingersPosition in
                        handleFingersPosition(fingersPosition)
                    }
                }
            }
        }
    }

    private func drawLines() -> some ChartContent {
        ForEach(chartData.lineData.entries) { entry in
            drawChartMarkWithEntry(entry, chartState: fingersPosition.atLeastOneFingerPressed ? .neutral : chartData.lineData.chartState)
                    .opacity(subChartState == nil ? 1 : 0.5)
                
            drawAreaMarkWithEntry(entry: entry, chartState: fingersPosition.atLeastOneFingerPressed ? .neutral : chartData.lineData.chartState)
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
        
        guard chartData.lineData.entries.indices.contains(startIndex), endIndex >= 0, endIndex <  chartData.lineData.entries.count else {
            return false
        }
        
        return entry.xValue >= chartData.lineData.entries[startIndex].xValue  && entry.xValue <= chartData.lineData.entries[endIndex].xValue
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
        
        guard chartData.lineData.entries.indices.contains(startIndex), endIndex >= 0, endIndex < chartData.lineData.entries.count else {
            subChartState = nil
            return
        }
        
        let startEntry = chartData.lineData.entries[startIndex]
        let endEntry = chartData.lineData.entries[endIndex]
        
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
    LineChartView(chartData: .init(lineData: .init(chartState: .increasing, entries: [], scaleX: .init(minimumX: 0, maximumX: 0), scaleY: .init(minimumY: 0, maximumY: 0)),
                                   candleData: [],
                                   barData: []))
}
