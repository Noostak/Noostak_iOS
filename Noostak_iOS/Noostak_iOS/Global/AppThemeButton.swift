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
    
    init(theme: Theme = .grayScale, title: String = "다음") {
        self.theme = theme
        self.title = title
        super.init(frame: .zero)
        setupUI()
        updateUI(for: .disable)
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
    
    private func updateUI(for state: State) {
        self.backgroundColor = theme.backgroundColor(state)
        self.isEnabled = state.isEnabled
    }
}

// MARK: - Interface
extension AppThemeButton {
    func bind(state: Observable<AppThemeButton.State>) {
        state
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.updateUI(for: state)
            })
            .disposed(by: disposeBag)
    }
}

extension AppThemeButton {

    /// 버튼의 활성/비활성 상태
    enum State {
        case able
        case disable
        
        var isEnabled: Bool {
            switch self {
            case .able:
                return true
            case .disable:
                return false
            }
        }
    }
    
    /// 버튼의 컬러 웨이
    enum Theme {
        case colorScale
        case grayScale
        
        var foregroundColor: UIColor {
            return .white
        }
        
        func backgroundColor(_ state: AppThemeButton.State) -> UIColor {
            switch state {
                
            case .able:
                return self == .colorScale ? .appBlue600 : .appGray900
            case .disable:
                return .appGray500
            }
        }
    }
}
