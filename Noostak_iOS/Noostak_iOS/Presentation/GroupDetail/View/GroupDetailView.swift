//
//  GroupDetailView.swift
//  Noostak_iOS
//
//  Created by 오연서 on 1/31/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class GroupDetailView: UIView {

    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    // MARK: Views
    private let profileImageView = UIImageView()
    private let groupNameLabel = UILabel()
    private lazy var shareButton = UIButton()
    private lazy var groupMemberButton = UIButton()
    private let scheduleListLabel = UILabel()
    let segmentedControl = UISegmentedControl(items: ["진행 중", "확정"])
    private let underlineView = UIView()
    private let selectedUnderlineView = UIView()
    let defaultLabel = UILabel()
    let inProgressCollectionView: UICollectionView
    let confirmedCollectionView: UICollectionView
    
    // MARK: Init
    override init(frame: CGRect) {
        let inProgressLayout = UICollectionViewFlowLayout()
        let confirmedLayout = UICollectionViewFlowLayout()
        self.inProgressCollectionView = UICollectionView(frame: .zero, collectionViewLayout: inProgressLayout)
        self.confirmedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: confirmedLayout)
        super.init(frame: frame)
        setUpFoundation()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        bindSegmentControl()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [profileImageView, groupNameLabel, shareButton, groupMemberButton, scheduleListLabel,
         segmentedControl, underlineView, selectedUnderlineView,
          inProgressCollectionView, confirmedCollectionView, defaultLabel].forEach {
            self.addSubview($0)
        }
    }
    
    private func setUpFoundation() {
        self.backgroundColor = .appWhite
    }
    // MARK: setUpUI
    private func setUpUI() {
        profileImageView.do {
            $0.layer.cornerRadius = 7.14
            $0.image = .icGroupDefault
        }
        
        groupNameLabel.do {
            $0.font = .PretendardStyle.h1_b.font
            $0.textColor = .appGray900
            $0.text = "누스탁"
        }
        
        shareButton.do {
            $0.setImage(.icShare, for: .normal)
        }
        
        groupMemberButton.do {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .clear
            config.baseForegroundColor = .appGray800
            config.attributedTitle = AttributedString("그룹 멤버 8",
                                                      attributes: AttributeContainer([.font: UIFont.PretendardStyle.b2_r.font]))
            config.image = .icVector
            config.imagePlacement = .trailing
            config.imagePadding = 5
            config.contentInsets = .zero
            $0.configuration = config

        }
        
        scheduleListLabel.do {
            $0.font = .PretendardStyle.b1_sb.font
            $0.textColor = .appGray800
            $0.text = "약속 리스트"
        }
        
        segmentedControl.do {
            $0.selectedSegmentIndex = 0
            $0.selectedSegmentTintColor = .clear
            $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
            $0.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appGray900,
                                       NSAttributedString.Key.font: UIFont.PretendardStyle.b1_sb.font], for: .selected)
            $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appGray500,
                                       NSAttributedString.Key.font: UIFont.PretendardStyle.b1_sb.font], for: .normal)
        }
        
        underlineView.do {
            $0.backgroundColor = .appGray200
            $0.layer.cornerRadius = 2
        }
        
        selectedUnderlineView.do {
            $0.backgroundColor = .appGray900
            $0.layer.cornerRadius = 2
        }
        
        defaultLabel.do {
            $0.font = .PretendardStyle.b2_r.font
            $0.textColor = .appGray900
            $0.isHidden = true
        }
        
        inProgressCollectionView.do {
            $0.isHidden = false
        }

        confirmedCollectionView.do {
            $0.isHidden = true
        }
    }

    // MARK: setUpLayout
    private func setUpLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(21)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(40)
        }
        
        groupNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        shareButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        groupMemberButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(9)
            $0.leading.equalTo(profileImageView)
        }
        
        scheduleListLabel.snp.makeConstraints {
            $0.top.equalTo(groupMemberButton.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(17)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(scheduleListLabel.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(22)
        }
        
        underlineView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(4)
        }
        
        selectedUnderlineView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(16)
            $0.leading.equalTo(segmentedControl.snp.leading)
            $0.width.equalTo(segmentedControl.snp.width).dividedBy(2)
            $0.height.equalTo(4)
        }
        
        defaultLabel.snp.makeConstraints {
            $0.top.equalTo(selectedUnderlineView.snp.bottom).offset(142)
            $0.centerX.equalToSuperview()
        }
        
        inProgressCollectionView.snp.makeConstraints {
            $0.top.equalTo(selectedUnderlineView.snp.bottom).offset(19)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        confirmedCollectionView.snp.makeConstraints {
            $0.top.equalTo(selectedUnderlineView.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Bind Methods
    private func bindSegmentControl() {
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                let segmentWidth = self.segmentedControl.frame.width / 2
                let leadingDistance = CGFloat(index) * segmentWidth
                
                UIView.animate(withDuration: 0.2) {
                    self.selectedUnderlineView.snp.updateConstraints {
                        $0.leading.equalTo(self.segmentedControl.snp.leading).offset(leadingDistance)
                    }
                    self.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
}
