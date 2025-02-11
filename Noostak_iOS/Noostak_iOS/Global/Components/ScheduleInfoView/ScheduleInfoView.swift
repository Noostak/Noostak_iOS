//
//  ScheduleInfoView.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/11/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

enum ScheduleState {
    case inProgress
    case confirmed
}

final class ScheduleInfoView: UIView {
    // MARK: Properties
    var disposeBag = DisposeBag()
    private var state: ScheduleState
    
    // MARK: Views
    let scheduleDurationLabel = UILabel()
    let likeButton = LikeButton()
    private let scheduleInfoView = UIView()
    private let scheduleTimeTitleLabel = UILabel()
    let scheduleTimeLabel = UILabel()
    private let scheduleCategoryLabel = UILabel()
    var scheduleCategoryChip = ScheduleCategoryButton(category: .hobby, buttonType: .ReadOnly)
    let availableLabel = UILabel()
    var availableCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let unavailableLabel = UILabel()
    var unavailableCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: Init
    init(state: ScheduleState) {
        self.state = state
        super.init(frame: .zero)
        setUpFoundation()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        self.addSubview(scheduleInfoView)
        [scheduleDurationLabel, likeButton, scheduleTimeTitleLabel, scheduleTimeLabel,
         scheduleCategoryLabel, scheduleCategoryChip,
         availableLabel, availableCollectionView,
         unavailableLabel, unavailableCollectionView].forEach {
            scheduleInfoView.addSubview($0)
        }
    }
    
    private func setUpFoundation() {
        self.backgroundColor = .appWhite
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        scheduleDurationLabel.do {
            $0.font = .PretendardStyle.t4_b.font
            $0.textColor = .appBlack
        }
        
        likeButton.do {
            $0.isHidden = true
        }
        
        scheduleInfoView.do {
            $0.layer.cornerRadius = 20
            $0.layer.borderColor = UIColor.appGray100.cgColor
            $0.layer.borderWidth = 1
        }
        
        scheduleTimeTitleLabel.do {
            $0.text = "약속 시간"
            $0.font = .PretendardStyle.c3_r.font
            $0.textColor = .appBlack
        }
        
        scheduleTimeLabel.do {
            $0.font = .PretendardStyle.b4_sb.font
            $0.textColor = .appBlack
        }
        
        scheduleCategoryLabel.do {
            $0.text = "약속 유형"
            $0.font = .PretendardStyle.c3_r.font
            $0.textColor = .appBlack
        }
        
        availableLabel.do {
            $0.font = .PretendardStyle.c3_r.font
            $0.textColor = .appBlack
        }
        
        unavailableLabel.do {
            $0.font = .PretendardStyle.c3_r.font
            $0.textColor = .appBlack
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        scheduleInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.bottom.equalTo(unavailableCollectionView.snp.bottom).offset(16)
        }
        
        scheduleDurationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(30)
            $0.width.equalTo(50)
        }
        
        scheduleTimeTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }
        
        scheduleTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(scheduleTimeTitleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        scheduleCategoryLabel.snp.makeConstraints {
            $0.top.equalTo(scheduleTimeTitleLabel.snp.bottom).offset(26)
            $0.leading.equalTo(scheduleTimeTitleLabel)
        }
        
        scheduleCategoryChip.snp.makeConstraints {
            $0.centerY.equalTo(scheduleCategoryLabel)
            $0.trailing.equalTo(scheduleTimeLabel)
            $0.height.equalTo(30)
            $0.width.equalTo(53)
        }
        
        availableLabel.snp.makeConstraints {
            $0.leading.equalTo(scheduleTimeTitleLabel)
        }
        
        availableCollectionView.snp.makeConstraints {
            $0.top.equalTo(availableLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        unavailableLabel.snp.makeConstraints {
            $0.top.equalTo(availableCollectionView.snp.bottom).offset(20)
            $0.leading.equalTo(scheduleTimeTitleLabel)
        }
        
        unavailableCollectionView.snp.makeConstraints {
            $0.top.equalTo(unavailableLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    private func updateUI() {
        switch state {
        case .inProgress:
            scheduleDurationLabel.isHidden = false
            likeButton.isHidden = false
            scheduleTimeTitleLabel.isHidden = true
            scheduleTimeLabel.isHidden = true
            scheduleCategoryLabel.isHidden = true
            scheduleCategoryChip.isHidden = true
            
            availableLabel.snp.remakeConstraints {
                $0.top.equalTo(scheduleDurationLabel.snp.bottom).offset(16)
                $0.leading.equalTo(scheduleDurationLabel)
            }
            
        case .confirmed:
            scheduleDurationLabel.isHidden = true
            likeButton.isHidden = true
            scheduleTimeTitleLabel.isHidden = false
            scheduleTimeLabel.isHidden = false
            scheduleCategoryLabel.isHidden = false
            scheduleCategoryChip.isHidden = false
            
            availableLabel.snp.remakeConstraints {
                $0.top.equalTo(scheduleCategoryLabel.snp.bottom).offset(26)
                $0.leading.equalTo(scheduleTimeTitleLabel)
            }
        }
    }
}

// MARK: - 셀 좌측 정렬
final class LeftAlignedFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var rowAttributes: [UICollectionViewLayoutAttributes] = []
        var previousY: CGFloat = -1
        var rowStartX: CGFloat = 0
        
        for attribute in attributes {
            let frame = attribute.frame
            let currentY = frame.origin.y
            
            if currentY != previousY {
                alignRow(rowAttributes, rowStartX: rowStartX)
                rowAttributes.removeAll()
                rowStartX = sectionInset.left
            }
            rowAttributes.append(attribute)
            previousY = currentY
        }
        alignRow(rowAttributes, rowStartX: rowStartX) // 마지막 줄 정렬
        return attributes
    }
    
    func alignRow(_ rowAttributes: [UICollectionViewLayoutAttributes], rowStartX: CGFloat) {
        guard !rowAttributes.isEmpty else { return }
        
        var currentX = rowStartX
        for attribute in rowAttributes {
            attribute.frame.origin.x = currentX
            currentX += attribute.frame.width + minimumInteritemSpacing
        }
    }
}
