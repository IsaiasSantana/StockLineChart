//
//  Color+Colors.swift
//  StockLineChart
//
//  Created by Isaías Santana on 01/02/24.
//

import Foundation
import SwiftUI

extension Color {
    static let decreasingColor = Color(red: 0.96, green: 0.31, blue: 0.21)
    static let increasingColor = Color(red: 0, green: 0.61, blue: 0.27)
    static let neutralColor = Color.cyan
}

extension ShapeStyle where Self == Color {
    static var decreasingColor: Color {
        .decreasingColor
    }
    
    static var increasingColor:  Color {
        .increasingColor
    }
    
    static var neutralColor: Color {
        .cyan
    }
}
