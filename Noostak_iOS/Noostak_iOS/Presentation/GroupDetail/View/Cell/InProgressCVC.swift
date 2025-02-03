//
//  InProgressCVC.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/1/25.
//

import UIKit
import SnapKit
import Then
import ReactorKit

final class InProgressCVC: UICollectionViewCell, View {
    
    // MARK: Properties
    static let identifier = "InProgressCVC"
    var disposeBag = DisposeBag()
    
    // MARK: Views
    private let content = UIView()
    private let scheduleTitleLabel = UILabel()
    private let moveButton = UIButton()
    private let timeLabel = UILabel()
    private let availabilityLabel = UILabel()
    private let backgroundProgressBar = UIView()
    private let progressBar = UIView()

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
        self.addSubview(content)
        [scheduleTitleLabel, scheduleTitleLabel, moveButton, timeLabel, availabilityLabel, backgroundProgressBar, progressBar].forEach {
            content.addSubview($0)
        }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        content.do {
            $0.backgroundColor = .appWhite
            $0.layer.borderColor = UIColor.appGray200.cgColor
            $0.layer.cornerRadius = 15
            $0.layer.borderWidth = 1
        }
        
        scheduleTitleLabel.do {
            $0.font = .PretendardStyle.b4_sb.font
            $0.textColor = .appGray900
        }
        
        moveButton.do {
            $0.setImage(.icVector, for: .normal)
        }
        
        timeLabel.do {
            $0.font = .PretendardStyle.b5_r.font
            $0.textColor = .appGray800
        }
        
        availabilityLabel.do {
            $0.font = .PretendardStyle.b5_r.font
            $0.textColor = .appGray700
        }
        
        backgroundProgressBar.do {
            $0.backgroundColor = .appGray200
            $0.layer.cornerRadius = 2
        }
        
        progressBar.do {
            $0.backgroundColor = .appBlue300
            $0.layer.cornerRadius = 2
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        content.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scheduleTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(19)
            $0.leading.equalToSuperview().offset(16)
        }
        
        moveButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(22)
            $0.size.equalTo(18)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(scheduleTitleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(scheduleTitleLabel)
        }
        
        availabilityLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        backgroundProgressBar.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(4)
        }
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(10)
            $0.leading.equalTo(backgroundProgressBar)
            $0.height.equalTo(4)
        }
    }
}

extension InProgressCVC {
    func bind(reactor: InProgressCellReactor) {
        let schedule = reactor.currentState.schedule
        scheduleTitleLabel.text = schedule.schedule.name
        timeLabel.text = NSTDateUtility.durationList(schedule.startTime, schedule.endTime)
        availabilityLabel.text = "\(schedule.availableMemberCount) / \(schedule.groupMemberCount)"
        progressBar.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(10)
            $0.leading.equalTo(backgroundProgressBar)
            $0.width.equalTo(50)
            $0.height.equalTo(4)
        }
    }
}
