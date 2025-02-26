//
//  AppThemeButton.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/6/25.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import ReactorKit

/// 앱 전반적으로 사용되는 앱 테마 버튼입니다
final class AppThemeButton: UIButton {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let theme: AppThemeButton.Theme
    private let title: String
    private let _isEnabledRelay = BehaviorRelay<Bool>(value: false)
    
    init(theme: Theme = .grayScale, title: String = "다음") {
        self.theme = theme
        self.title = title
        super.init(frame: .zero)
        setupUI()
        updateUI(isEnabled: false)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpUI
    private func setupUI() {
        self.layer.cornerRadius = 8
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .PretendardStyle.t3_b.font
        self.setTitleColor(theme.foregroundColor, for: .normal)
    }
    
    private func updateUI(isEnabled: Bool) {
        self.backgroundColor = theme.backgroundColor(isEnabled)
        self.isEnabled = isEnabled
    }
    
    private func bind() {
        isEnabledRelay
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEnabled in
                self?.updateUI(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
    }
}

extension AppThemeButton {
    
    /// 버튼의 컬러 웨이
    enum Theme {
        case colorScale
        case grayScale
        
        var foregroundColor: UIColor {
            return .white
        }
        
        func backgroundColor(_ availability: Bool) -> UIColor {
            return availability
            ? self == .colorScale ? .appBlue600 : .appGray900
            : .appGray500
        }
    }
}

// MARK: - Interface
extension AppThemeButton {
    var isEnabledRelay: BehaviorRelay<Bool> {
        return _isEnabledRelay
    }
}

// MARK: Rx Extension
extension Reactive where Base: AppThemeButton {
    var isEnabled: ControlProperty<Bool> {
        let isEnabledRelay = base.isEnabledRelay

        return ControlProperty(
            values: isEnabledRelay.asObservable(),
            valueSink: Binder(base) { button, state in
                button.isEnabledRelay.accept(state)
            }
        )
    }
}
