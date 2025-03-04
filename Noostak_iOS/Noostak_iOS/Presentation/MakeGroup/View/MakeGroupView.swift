//
//  MakeGroupView.swift
//  Noostak_iOS
//
//  Created by 박민서 on 3/1/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class MakeGroupView: UIView {

    // MARK: Views
    private let titleLabel = UILabel()
    let profileImagePicker = ProfileImagePicker()
    let nameTextField = AppColorTextField(
        placeholder: "그룹명을 입력해주세요",
        countLimit: 30,
        activateDeleteButton: true
    )
    let bottomButton = AppThemeButton(theme: .colorScale)
    
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
            titleLabel,
            profileImagePicker,
            nameTextField,
            bottomButton
        ].forEach { self.addSubview($0) }
    }

    // MARK: setUpUI
    private func setUpUI() {
        titleLabel.do {
            $0.attributedText = "그룹 만들기".pretendardStyled(style: .h2_b, color: .appBlack)
        }
    }

    // MARK: setUpLayout
    private func setUpLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(50)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        profileImagePicker.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(44)
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
