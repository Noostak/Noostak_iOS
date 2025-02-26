//
//  SignUpCompleteView.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/25/25.
//

import UIKit
import Then
import SnapKit

final class SignUpCompleteView: UIView {
    
    // MARK: Properties
    private let name: String

    // MARK: Views
    private let firstTitleLabel = UILabel()
    private let secondTitleLabel = UILabel()
    private let centerImageView = UIImageView()
    let noGroupButton = UIButton()
    let enterGroupCodeButton = AppThemeButton(theme: .colorScale, title: "그룹코드 입력하기", isEnabled: true)
    
    // MARK: Init
    init(name: String) {
        self.name = name
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
            firstTitleLabel,
            secondTitleLabel,
            centerImageView,
            noGroupButton,
            enterGroupCodeButton
        ].forEach { self.addSubview($0) }
    }

    // MARK: setUpUI
    private func setUpUI() {
        firstTitleLabel.do {
            $0.attributedText = "환영해요 \(name)님!".pretendardStyled(style: .t1_sb, color: .appGray900)
        }
        
        secondTitleLabel.do {
            $0.attributedText = "그룹코드를 받으셨나요?".pretendardStyled(style: .t1_sb, color: .appGray900)
        }
        
        centerImageView.do {
            $0.image = .imgGroupCode
        }
        
        noGroupButton.do {
            let noInvitationText = "아니요, 초대받은 그룹이 없어요.".pretendardStyled(style: .c3_r, color: .appGray800)
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
        firstTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(130)
            $0.centerX.equalToSuperview()
        }
        
        secondTitleLabel.snp.makeConstraints {
            $0.top.equalTo(firstTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        centerImageView.snp.makeConstraints {
            $0.top.equalTo(secondTitleLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        noGroupButton.snp.makeConstraints {
            $0.bottom.equalTo(enterGroupCodeButton.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        enterGroupCodeButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
    }
}
