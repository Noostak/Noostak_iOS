//
//  GroupMemberView.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/9/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class GroupMemberView: UIView {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    // MARK: Views
    let groupProfileImageView = UIImageView()
    let groupNameLabel = UILabel()
    private lazy var shareButton = UIButton()
    let groupMemberTotalLabel = UILabel()
    let groupHostLabel = UILabel()
    let groupHostProfile = UIImageView()
    let groupHostName = UILabel()
    private let divider = UIView()
    let groupMemberLabel = UILabel()
    var groupMemberCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let defaultLabel = UILabel()

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFoundation()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [groupProfileImageView, groupNameLabel, shareButton, groupMemberTotalLabel, groupHostLabel,
         groupHostProfile, groupHostName, divider, groupMemberLabel, groupMemberCollectionView, defaultLabel].forEach {
            self.addSubview($0)
        }
    }
    
    private func setUpFoundation() {
        self.backgroundColor = .appWhite
    }
    // MARK: setUpUI
    private func setUpUI() {
        groupProfileImageView.do {
            $0.layer.cornerRadius = 7.14
            $0.image = .icGroupDefault
        }
        
        groupNameLabel.do {
            $0.font = .PretendardStyle.h1_b.font
            $0.textColor = .appGray900
        }
        
        shareButton.do {
            $0.setImage(.icShare, for: .normal)
        }
        
        groupMemberTotalLabel.do {
            $0.font = .PretendardStyle.b2_r.font
            $0.textColor = .appGray800
        }
        
        groupHostLabel.do {
            $0.text = "방장"
            $0.font = .PretendardStyle.b4_sb.font
            $0.textColor = .appGray700
        }
        
        groupHostProfile.do {
            $0.layer.cornerRadius = 36
            $0.image = .imgProfileFilled
        }
        
        groupHostName.do {
            $0.font = .PretendardStyle.c3_sb.font
            $0.textColor = .appGray900
        }
        
        divider.do {
            $0.backgroundColor = .appGray200
        }
        
        groupMemberLabel.do {
            $0.font = .PretendardStyle.b4_sb.font
            $0.textColor = .appGray700
        }
        
        defaultLabel.do {
            $0.text = "아직 그룹 멤버가 없어요\n멤버를 초대하고 그룹을 만들어보세요"
            $0.font = .PretendardStyle.b2_r.font
            $0.textColor = .appGray900
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.isHidden = true
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        groupProfileImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(21)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(40)
        }
        
        groupNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(groupProfileImageView)
            $0.leading.equalTo(groupProfileImageView.snp.trailing).offset(8)
        }
        
        shareButton.snp.makeConstraints {
            $0.top.equalTo(groupProfileImageView)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        groupMemberTotalLabel.snp.makeConstraints {
            $0.top.equalTo(groupProfileImageView.snp.bottom).offset(9)
            $0.leading.equalTo(groupProfileImageView)
        }
        
        groupHostLabel.snp.makeConstraints {
            $0.top.equalTo(groupMemberTotalLabel.snp.bottom).offset(22)
            $0.leading.equalTo(groupMemberTotalLabel)
        }
        
        groupHostProfile.snp.makeConstraints {
            $0.top.equalTo(groupHostLabel.snp.bottom).offset(14)
            $0.leading.equalTo(groupMemberTotalLabel)
            $0.size.equalTo(72)
        }
        
        groupHostName.snp.makeConstraints {
            $0.top.equalTo(groupHostProfile.snp.bottom).offset(4)
            $0.centerX.equalTo(groupHostProfile)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(groupHostName.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1.5)
        }
        
        groupMemberLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(20)
            $0.leading.equalTo(groupMemberTotalLabel)
        }
        
        groupMemberCollectionView.snp.makeConstraints {
            $0.top.equalTo(groupMemberLabel.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        defaultLabel.snp.makeConstraints {
            $0.top.equalTo(groupMemberLabel.snp.bottom).offset(39)
            $0.centerX.equalToSuperview()
        }
    }
}
