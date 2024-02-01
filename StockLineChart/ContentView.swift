//
//  ContentView.swift
//  StockLineChart
//
//  Created by Isaías Santana on 29/01/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    @State private var chartData: LineChartData?
    
    var body: some View {
        ZStack {
            if chartData == nil {
                EmptyView()
            }
            
            if let chartData {
                LineChartView(chartData: chartData)
                    .frame(height: 200)
            }
        }.task {
            chartData = await LineChartDataProvider().fetchLineChartData()
        }
    }
}

#Preview {
    ContentView()
}
