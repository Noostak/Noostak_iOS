//
//  CapsuleButton.swift
//  Noostak_iOS
//
//  Created by 이자민 on 1/9/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class CapsuleButton: UIButton {
    
    // MARK: - Enum
    enum CapsuleButtonType {
        case expand(isExpanded: Bool)
        case normal
    }
    
    // MARK: - Properties
    var capsuleButtonType: CapsuleButtonType
    private var action: (() -> Void)?
    private var widthConstraint: Constraint?
    private let defaultTitle: String
    
    // MARK: - Initializer
    init(type: CapsuleButtonType, title: String, icon: UIImage?, action: (() -> Void)? = nil) {
        self.defaultTitle = title
        self.capsuleButtonType = type
        self.action = action
        super.init(frame: .zero)
        setupUI()
        configure(title: title, icon: icon)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.do {
            $0.backgroundColor = .appBlack
            $0.layer.cornerRadius = 25
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(50)
            self.widthConstraint = $0.width.equalTo(100).constraint
        }
    }
    
    private func configure(title: String, icon: UIImage?) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.appWhite, for: .normal)
        self.titleLabel?.font = .PretendardStyle.b4_sb.font
        self.setImage(icon, for: .normal)
        self.tintColor = .appWhite
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    private func updateWidth(isExpanded: Bool) {

    }
    
    private func updateButton(isExpanded: Bool) {
        let title = isExpanded ? "" : defaultTitle
        let icon = isExpanded ? UIImage(systemName: "xmark") : UIImage(systemName: "plus")
        configure(title: title, icon: icon)
        
        self.backgroundColor = isExpanded ? .appBlue50 : .appBlack
        self.setTitleColor(isExpanded ? .appBlack : .appWhite, for: .normal)
        self.tintColor = isExpanded ? .appBlack : .appWhite
        
        let newWidth = isExpanded ? 50 : 100
        self.widthConstraint?.update(offset: newWidth)
        UIView.animate(withDuration: 0.3) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        switch capsuleButtonType {
        case .expand(let isExpanded):
            let newState = !isExpanded
            capsuleButtonType = .expand(isExpanded: newState)
            updateButton(isExpanded: newState)
            action?()
        case .normal:
            action?()
        }
    }

}
