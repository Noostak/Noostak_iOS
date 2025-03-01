//
//  MakeGroupCompleteView.swift
//  Noostak_iOS
//
//  Created by 박민서 on 3/1/25.
//

import UIKit
import Then
import SnapKit

final class MakeGroupCompleteView: UIView {
    
    // MARK: Properties
    private let groupCode: String

    // MARK: Views
    let topBar = AppNavigationBar()
    private let topImageView = UIImageView()
    private let firstTitleLabel = UILabel()
    private let secondTitleLabel = UILabel()
    private let groupCodeLabel = UILabel()
    let copyGroupCodeButton = UIButton()
    let sendGroupCodeButton = AppThemeButton(theme: .colorScale, title: "그룹코드 보내기", isEnabled: true)
    
    // MARK: Init
    init(groupCode: String) {
        self.groupCode = groupCode
        super.init(frame: .zero)
        setUpFoundation()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.backgroundColor = .white
    }

    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            topBar,
            topImageView,
            firstTitleLabel,
            secondTitleLabel,
            groupCodeLabel,
            copyGroupCodeButton,
            sendGroupCodeButton
        ].forEach { self.addSubview($0) }
    }

    // MARK: setUpUI
    private func setUpUI() {
        topBar.do {
            $0.setLeftItem(image: UIImage(resource: .icnDelete28))
        }
        
        topImageView.do {
            $0.image = .imgGroupPen
        }
        
        firstTitleLabel.do {
            $0.attributedText = "그룹 만들기가 완료되었습니다".pretendardStyled(style: .t1_sb, color: .appGray900)
        }
        
        secondTitleLabel.do {
            $0.attributedText = "그룹코드를 복사해\n그룹원을 초대해주세요!".pretendardStyled(style: .b4_r, color: .appGray900)
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
        
        groupCodeLabel.do {
            $0.attributedText = groupCode.pretendardStyled(style: .code_m, color: .appGray800)
        }
        
        copyGroupCodeButton.do {
            let noInvitationText = "그룹코드 복사하기".pretendardStyled(style: .c3_r, color: .appGray800)
            let mutableText = NSMutableAttributedString(attributedString: noInvitationText)
            mutableText.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSRange(location: 0, length: mutableText.length))
            
            var config = UIButton.Configuration.plain()
            config.attributedTitle = AttributedString(mutableText)
            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
            
            $0.configuration = config
        }
    }

    // MARK: setUpLayout
    private func setUpLayout() {
        topBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        topImageView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom).offset(38)
            $0.centerX.equalToSuperview()
        }
        
        firstTitleLabel.snp.makeConstraints {
            $0.top.equalTo(topImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        secondTitleLabel.snp.makeConstraints {
            $0.top.equalTo(firstTitleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        groupCodeLabel.snp.makeConstraints {
            $0.top.equalTo(secondTitleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        copyGroupCodeButton.snp.makeConstraints {
            $0.bottom.equalTo(sendGroupCodeButton.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        sendGroupCodeButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
    }
}
