//
//  MemberAvailabilityChip.swift
//  Noostak_iOS
//
//  Created by 오연서 on 1/6/25.
//

import UIKit
import Then
import SnapKit

enum MemberStatus {
    case myself
    case available
    case unavailable
}

final class MemberAvailabilityChip: UIView {
    
    private let chipLabel = UILabel()
    private var status: MemberStatus = .myself
    
    init(name: String, status: MemberStatus) {
        super.init(frame: .zero)
        self.chipLabel.text = name
        self.status = status
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    func update(name: String, status: MemberStatus) {
        self.chipLabel.text = name
        self.status = status
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        self.addSubview(chipLabel)
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        
        self.do {
            $0.layer.cornerRadius = 15
            $0.layer.borderWidth = 1
            
            switch status {
            case .myself:
                $0.backgroundColor = .appBlue200
                $0.layer.borderColor = UIColor.appBlue200.cgColor
            case .available:
                $0.backgroundColor = .appWhite
                $0.layer.borderColor = UIColor.appBlue200.cgColor
            case .unavailable:
                $0.backgroundColor = .appGray200
                $0.layer.borderColor = UIColor.appGray200.cgColor
            }
        }
        
        chipLabel.do {
            $0.font = .PretendardStyle.c3_r.font
            $0.textColor = .appBlack
            $0.textAlignment = .center
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        self.snp.makeConstraints {
            if status == .myself {
                $0.width.equalTo(39)
            }
            $0.height.equalTo(30)
        }
        chipLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.verticalEdges.equalToSuperview().inset(6)
        }
    }
}
