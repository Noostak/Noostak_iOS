//
//  MakeAppointmentTimeView.swift
//  Noostak_iOS
//
//  Created by 이명진 on 3/11/25.
//

import Foundation

import UIKit

final class MakeAppointmentTimeView: UIView {
    
    // MARK: - UIComponents
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        backgroundColor = .white
    }
    
    private func setHierarchy() {
        
    }
    
    private func setLayout() {
        
    }
    
}

