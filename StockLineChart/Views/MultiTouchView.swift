//
//  MultiTouchView.swift
//  StockLineChart
//
//  Created by Isaías Santana on 31/01/24.
//

import Foundation
import SwiftUI

protocol MultiTouchViewDelegate: AnyObject {
    func didTapFingers(at position: FingersPosition)
}

final class MultiTouchView: UIView {
    private let twoFingersGestureRecognizer = RangeTwoFingersGestureRecognizer()
    
    weak var delegate: MultiTouchViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        isMultipleTouchEnabled = true
        
        twoFingersGestureRecognizer.addTarget(self, action: #selector(didTapTwoFingersGesture))
        addGestureRecognizer(twoFingersGestureRecognizer)
    }
    
    @objc
    private func didTapTwoFingersGesture(_ recognizer: UIGestureRecognizer) {
        guard twoFingersGestureRecognizer.view === self else {
            return
        }
        
        delegate?.didTapFingers(at: twoFingersGestureRecognizer.fingersPosition())
    }
}
