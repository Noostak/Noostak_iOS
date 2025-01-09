//
//  ScheduleCategoryButton.swift
//  Noostak_iOS
//
//  Created by 오연서 on 1/8/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ScheduleCategoryButton: UIButton {
    // MARK: Properties
    private var category: ScheduleCategory?
    private var categoryButtonType: ButtonType = .Input
    private let disposeBag = DisposeBag()
    private let isSelectedSubject = BehaviorRelay<Bool>(value: false)
        
    // MARK: Init
    init(category: ScheduleCategory, buttonType: ButtonType) {
        super.init(frame: .zero)
        self.category = category
        self.categoryButtonType = buttonType
        self.setTitle(category.name, for: .normal)
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        switch categoryButtonType {
        case .Input:
            /// 입력 모드: 선택 여부에 따라 색상 변경
            self.isUserInteractionEnabled = true
            self.titleLabel?.font = .PretendardStyle.b4_sb.font
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 18.5
            bindUI()
        case .ReadOnly:
            /// 표시 모드: 컬러 칩 스타일
            guard let category = category else { return }
            self.isUserInteractionEnabled = false
            self.backgroundColor = category.displayColor
            self.setTitleColor(category == .other ? .appGray800 : .appWhite, for: .normal)
            self.layer.borderColor = UIColor.appWhite.cgColor
            self.titleLabel?.font = .PretendardStyle.c2_sb.font
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 15
        }
    }
    
    private func setUpLayout() {
        self.snp.makeConstraints {
            switch categoryButtonType {
            case .Input:
                $0.height.equalTo(37)
                $0.width.equalTo(66)
            case .ReadOnly:
                $0.height.equalTo(30)
                $0.width.equalTo(53)
            }
        }
    }
    
    private func bindUI() {
        isSelectedSubject
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isSelected in
                guard let self = self else { return }
                self.backgroundColor = isSelected ? .appBlack : .appWhite
                self.layer.borderColor = isSelected ? UIColor.appBlack.cgColor : UIColor.appGray200.cgColor
                self.setTitleColor(isSelected ? .appWhite : .appBlack, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}

extension ScheduleCategoryButton {
    enum ButtonType {
        case Input
        case ReadOnly
    }
}
