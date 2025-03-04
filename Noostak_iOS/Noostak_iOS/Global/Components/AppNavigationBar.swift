//
//  AppNavigationBar.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/26/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

/// 앱 전반적으로 사용되는 앱 테마 네비게이션 바입니다
final class AppNavigationBar: UIView {
    
    // MARK: Properties
    static let navBarHeight: CGFloat = 48
    static let buttonSize: CGFloat = 42
    
    // MARK: Views
    private let titleLabel = UILabel()
    private let _leftButton = UIButton()
    private let _rightButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.snp.updateConstraints {
            $0.height.equalTo(AppNavigationBar.navBarHeight + UIScreen.safeAreaTop)
        }
        
        titleLabel.snp.updateConstraints {
            $0.top.equalToSuperview().offset(AppNavigationBar.navBarHeight/2 + UIScreen.safeAreaTop)
        }
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        self.addSubviews(_leftButton, titleLabel, _rightButton)
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        self.backgroundColor = .white
        
        titleLabel.do {
            $0.font = .PretendardStyle.b2_r.font
            $0.textColor = .appBlack
            $0.textAlignment = .center
        }
        
        _leftButton.do {
            $0.isHidden = true
        }
        
        _rightButton.do {
            $0.isHidden = true
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(AppNavigationBar.navBarHeight)
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(AppNavigationBar.navBarHeight/2)
        }
        
        _leftButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(7)
            $0.centerY.equalTo(titleLabel)
            $0.size.equalTo(AppNavigationBar.buttonSize)
        }
        
        _rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-7)
            $0.centerY.equalTo(titleLabel)
            $0.size.equalTo(AppNavigationBar.buttonSize)
        }
    }
}

// MARK: Interface
extension AppNavigationBar {
    /// 제목 설정
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    /// 왼쪽 아이템 추가
    func setLeftItem(image: UIImage = UIImage(resource: .icnLeft24), action: (() -> Void)? = nil) {
        _leftButton.setImage(image, for: .normal)
        _leftButton.isHidden = false
        if let action {
            _leftButton.addAction(UIAction { _ in action() }, for: .touchUpInside)
        }
    }
    
    /// 오른쪽 아이템 추가
    func setRightItem(image: UIImage, action: (() -> Void)? = nil) {
        _rightButton.setImage(image, for: .normal)
        _rightButton.isHidden = false
        if let action {
            _rightButton.addAction(UIAction { _ in action() }, for: .touchUpInside)
        }
    }
    
    /// 왼쪽 아이템 버튼
    var leftButton: UIButton {
        return self._leftButton
    }
    
    /// 우측 아이템 버튼
    var rightButton: UIButton {
        return self._rightButton
    }
}
