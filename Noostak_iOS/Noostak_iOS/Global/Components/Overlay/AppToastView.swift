//
//  AppToast.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/2/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class AppToastView: UIView {
    
    // MARK: Properties
    private var status: Status
    
    // MARK: Views
    private let messageLabel = UILabel()
    private let backgroundView = UIView()
    
    // MARK: Init
    init(status: Status) {
        self.status = status
        super.init(frame: .zero)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.layer.cornerRadius = backgroundView.frame.height / 2
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            backgroundView,
            messageLabel
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        messageLabel.do {
            $0.attributedText = status.attributedText
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        backgroundView.do {
            $0.backgroundColor = status.backgroundColor
            $0.layer.cornerRadius = 21 // layoutSubviews에서 조정됩니다
            $0.clipsToBounds = true
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        messageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(messageLabel).inset(-20)
            $0.verticalEdges.equalTo(messageLabel).inset(-12)
        }
    }
}

extension AppToastView {
    enum Status {
        case `default`(message: String)
        case `error`(message: String)
        
        var backgroundColor: UIColor {
            switch self {
                
            case .default:
                return .appGray800
            case .error:
                return .appPink
            }
        }
        
        var attributedText: NSAttributedString {
            switch self {
                
            case .default(let message):
                return message.pretendardStyled(style: .c3_r, color: .appWhite)
            case .error(let message):
                // TODO: 폰트 시스템 C3_SB 추가되면 수정
                return message.pretendardStyled(style: .c3_r, color: .appRed01)
            }
        }
    }
}

#Preview {
//    AppToastView(status: .default(message: "그룹 코드가 복사되었습니다"))
    AppToastView(status: .error(message: "최대 7일까지 선택할 수 있어요"))
}
