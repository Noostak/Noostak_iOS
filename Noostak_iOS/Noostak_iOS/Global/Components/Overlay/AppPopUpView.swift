//
//  AppPopUpView.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/28/25.
//

import UIKit
import SnapKit
import Then

final class AppPopUpView: UIView {
    // MARK: Views
    private let messageLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let primaryButton = UIButton()
    private let secondaryButton = UIButton()
    private let horizontalDivider = UIView()
    private let verticalDivider = UIView()
    
    private var primaryAction: (() -> Void)?
    private var secondaryAction: (() -> Void)?
    
    init(
        message: String,
        primaryTitle: String,
        secondaryTitle: String? = nil,
        primaryAction: (() -> Void)? = nil,
        secondaryAction: (() -> Void)? = nil
    ) {
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        super.init(frame: .zero)
        setUpFoundation()
        setUpHierarchy(isSecondary: secondaryTitle != nil)
        setUpUI(message: message, primaryTitle: primaryTitle, secondaryTitle: secondaryTitle)
        setUpLayout(isSecondary: secondaryTitle != nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        self.backgroundColor = .white
        
        primaryButton.addAction(.init(handler: { [weak self] _ in
            self?.primaryAction?()
            OverlayManager.shared.dismissPopup()
        }), for: .touchUpInside)
        
        secondaryButton.addAction(.init(handler: { [weak self] _ in
            self?.secondaryAction?()
            OverlayManager.shared.dismissPopup()
        }), for: .touchUpInside)
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy(isSecondary: Bool) {
        if isSecondary {
            buttonStackView.addArrangedSubview(secondaryButton)
            buttonStackView.addArrangedSubview(verticalDivider)
        }
        buttonStackView.addArrangedSubview(primaryButton)
        
        self.addSubviews(
            messageLabel,
            buttonStackView,
            horizontalDivider
        )
    }
    
    // MARK: setUpUI
    private func setUpUI(message: String, primaryTitle: String, secondaryTitle: String? = nil) {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        messageLabel.do {
            $0.font = .PretendardStyle.b4_r.font
            $0.textColor = .appGray900
            $0.text = message
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 0
        }
        
        primaryButton.do {
            $0.setAttributedTitle(primaryTitle.pretendardStyled(style: .c3_sb, color: .appBlue), for: .normal)
        }
        
        horizontalDivider.do {
            $0.backgroundColor = .appGray200
        }
        
        if let secondaryTitle {
            secondaryButton.do {
                $0.setAttributedTitle(secondaryTitle.pretendardStyled(style: .c3_sb, color: .appGray900), for: .normal)
            }
            
            verticalDivider.do {
                $0.backgroundColor = .appGray200
            }
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout(isSecondary: Bool) {
        messageLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(buttonStackView.snp.top)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(46)
        }
        
        horizontalDivider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.horizontalEdges.equalTo(buttonStackView)
        }
        
        if isSecondary {
            verticalDivider.snp.makeConstraints {
                $0.width.equalTo(1)
                $0.height.equalToSuperview()
            }
            
            secondaryButton.snp.makeConstraints {
                $0.width.equalTo(primaryButton)
            }
        }
    }
}

final class AppPopUpViewController: UIViewController {
    
    // MARK: Views
    private let popUpView: AppPopUpView
    
    init(popUpView: AppPopUpView) {
        self.popUpView = popUpView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appBlack.withAlphaComponent(0.6)
        setUpHierarchy()
        setUpLayout()
    }
    
    private func setUpHierarchy() {
        self.view.addSubview(popUpView)
    }
    
    private func setUpLayout() {
        popUpView.snp.makeConstraints {
            $0.width.equalTo(274)
            $0.height.equalTo(144)
            $0.center.equalToSuperview()
        }
    }
}
