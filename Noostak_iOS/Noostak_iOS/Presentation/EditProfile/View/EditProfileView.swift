//
//  EditProfileView.swift
//  Noostak_iOS
//
//  Created by 박민서 on 3/1/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class EditProfileView: UIView {

    // MARK: Views
    let navBar = AppNavigationBar()
    let profileImagePicker = ProfileImagePicker()
    let nameTextField = AppColorTextField(
        placeholder: "이름을 입력해주세요",
        countLimit: 10,
        activateDeleteButton: true
    )
    let bottomButton = AppThemeButton(theme: .colorScale, title: "확인")
    
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

    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.backgroundColor = .white
    }

    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            navBar,
            profileImagePicker,
            nameTextField,
            bottomButton
        ].forEach { self.addSubview($0) }
    }

    // MARK: setUpUI
    private func setUpUI() {
        navBar.do {
            $0.setTitle("프로필 수정")
            $0.setLeftItem()
        }
    }

    // MARK: setUpLayout
    private func setUpLayout() {
        navBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        profileImagePicker.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(26)
            $0.centerX.equalToSuperview()
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(profileImagePicker.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        bottomButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
    }
}
