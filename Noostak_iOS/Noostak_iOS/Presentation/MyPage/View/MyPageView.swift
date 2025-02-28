//
//  MyPageView.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/28/25.
//

import UIKit
import Then
import SnapKit

final class MyPageView: UIView {
    
    // MARK: Properties
    private let name: String
    private let profileImageURL: String
    
    // MARK: Views
    private let topBar = AppNavigationBar()
    private lazy var profileStackView = UIStackView(arrangedSubviews: [profileImageView, nameLabel])
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let profileEditButton = UIButton()
    private lazy var itemStackView = UIStackView(arrangedSubviews: [termsItem, logoutItem, withdrawItem])
    let termsItem = MyPageListItemView()
    let logoutItem = MyPageListItemView()
    let withdrawItem = MyPageListItemView()
    
    // MARK: Init
    init(name: String, profileImageURL: String) {
        self.name = name
        self.profileImageURL = profileImageURL
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
        self.addSubviews(
            topBar,
            profileStackView,
            profileEditButton,
            itemStackView
        )
    }

    // MARK: setUpUI
    private func setUpUI() {
        topBar.do {
            $0.setTitle("내 정보")
        }
        
        profileStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.alignment = .center
            $0.distribution = .fill
        }
        
        profileImageView.do {
            $0.image = .imgProfileFilled
        }
        
        nameLabel.do {
            $0.text = name
            $0.font = .PretendardStyle.t4_b.font
            $0.textColor = .appGray900
        }
        
        profileEditButton.do {
            $0.setAttributedTitle("프로필 수정".pretendardStyled(style: .c3_sb, color: .appGray900), for: .normal)
            $0.layer.cornerRadius = 6
            $0.layer.borderColor = UIColor.appGray200.cgColor
            $0.layer.borderWidth = 1
        }
        
        itemStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .fill
        }
        
        termsItem.do {
            $0.setTitle("약관 및 정책")
        }
        
        logoutItem.do {
            $0.setTitle("로그아웃")
        }
        
        withdrawItem.do {
            $0.setTitle("탈퇴하기")
        }
    }

    // MARK: setUpLayout
    private func setUpLayout() {
        topBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        profileStackView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom).offset(22)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(60)
        }
        
        profileEditButton.snp.makeConstraints {
            $0.height.equalTo(38)
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        itemStackView.snp.makeConstraints {
            $0.top.equalTo(profileEditButton.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(4)
        }
    }
}

final class MyPageListItemView: UIView {
    // MARK: Views
    private let titleLabel = UILabel()
    private var _rightButton = UIButton()
    
    // MARK: init
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
        self.addSubviews(titleLabel, _rightButton)
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        titleLabel.do {
            $0.font = .PretendardStyle.b5_r.font
            $0.textColor = .appGray900
        }
        
        _rightButton.do {
            var config = UIButton.Configuration.plain()
            config.image = .icnRight24
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            $0.configuration = config
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        _rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(48)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
}

// MARK: Interface
extension MyPageListItemView {
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    var rightButton: UIButton {
        return _rightButton
    }
}
