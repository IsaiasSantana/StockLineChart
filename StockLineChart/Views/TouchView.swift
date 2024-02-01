//
//  TouchView.swift
//  StockLineChart
//
//  Created by Isaías Santana on 01/02/24.
//

import Foundation
import SwiftUI

struct TouchView: UIViewRepresentable {
    private let onFingersPressed: (FingersPosition) -> Void
    
    init(onFingersPressed: @escaping (FingersPosition) -> Void) {
        self.onFingersPressed = onFingersPressed
    }

    func makeUIView(context: Context) -> MultiTouchView {
        let view = MultiTouchView(frame: .zero)
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: MultiTouchView, context: Context) {}
    
    func makeCoordinator() -> TouchCoordinator {
        TouchCoordinator(onFingersPressed: onFingersPressed)
    }
}

final class TouchCoordinator: MultiTouchViewDelegate {
    private let onFingersPressed: (FingersPosition) -> Void
    
    init(onFingersPressed: @escaping (FingersPosition) -> Void) {
        self.onFingersPressed = onFingersPressed
    }

    func didTapFingers(at position: FingersPosition) {
        onFingersPressed(position)
    }
}

