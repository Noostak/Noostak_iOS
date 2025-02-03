//
//  ConfirmedCVC.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/1/25.
//

import UIKit
import SnapKit
import Then
import ReactorKit

final class ConfirmedCVC: UICollectionViewCell, View {
    
    // MARK: Properties
    static let identifier = "ConfirmedCVC"
    var disposeBag = DisposeBag()
    
    // MARK: Views
    private let chip = UIView()
    private let scheduleTitleLabel = UILabel()
    private let timeLabel = UILabel()
    private let divider = UIView()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [chip, scheduleTitleLabel, timeLabel, divider].forEach {
            self.addSubview($0)
        }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        chip.do {
            $0.layer.cornerRadius = 6.5
        }
        
        scheduleTitleLabel.do {
            $0.font = .PretendardStyle.b4_sb.font
            $0.textColor = .appGray900
        }
        
        timeLabel.do {
            $0.font = .PretendardStyle.b5_r.font
            $0.textColor = .appGray800
        }
        
        divider.do {
            $0.backgroundColor = .appGray200
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        chip.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(6)
            $0.size.equalTo(13)
        }
        
        scheduleTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalTo(chip.snp.trailing).offset(9)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(scheduleTitleLabel.snp.bottom).offset(1)
            $0.leading.equalTo(scheduleTitleLabel)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

extension ConfirmedCVC {
    func bind(reactor: ConfirmedCellReactor) {
        let schedule = reactor.currentState.schedule
        chip.backgroundColor = schedule.schedule.category.displayColor
        scheduleTitleLabel.text = schedule.schedule.name
        timeLabel.text = NSTDateUtility.durationList(schedule.startTime, schedule.endTime)
    }
}
