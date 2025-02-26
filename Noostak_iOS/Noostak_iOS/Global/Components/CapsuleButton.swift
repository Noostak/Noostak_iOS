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
    enum Style {
        case expand(isExpanded: Bool)
        case normal
        
        var title: String {
            switch self {
            case .expand(let isExpanded):
                return isExpanded ? "" : "그룹 추가"
            case .normal:
                return "약속 만들기"
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .expand(let isExpanded):
                return isExpanded ? UIImage(systemName: "xmark") : UIImage(systemName: "plus")
            case .normal:
                return UIImage(systemName: "plus")
            }
        }
    }
    
    // MARK: - Properties
    var style: Style
    private var action: (() -> Void)?
    private var widthConstraint: Constraint?

    // MARK: - Initializer
    init(style: Style, action: (() -> Void)? = nil) {
        self.style = style
        self.action = action
        super.init(frame: .zero)
        setupUI()
        configure()
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.do {
            $0.backgroundColor = .appBlack
        }
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            self.layer.cornerRadius = self.frame.height / 2
        }
    
    private func configure() {
        self.setTitle(style.title, for: .normal)
        self.setTitleColor(.appWhite, for: .normal)
        self.titleLabel?.font = .PretendardStyle.b4_sb.font
        self.setImage(style.icon, for: .normal)
        self.tintColor = .appWhite
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    private func updateButton(isExpanded: Bool) {
        style = .expand(isExpanded: isExpanded)
        
        configure()
        self.backgroundColor = isExpanded ? .appBlue50 : .appBlack
        self.setTitleColor(isExpanded ? .appBlack : .appWhite, for: .normal)
        self.tintColor = isExpanded ? .appBlack : .appWhite
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        switch style {
        case .expand(let isExpanded):
            updateButton(isExpanded: !isExpanded)
            action?()
        case .normal:
            action?()
        }
    }
}

#Preview {
//    ViewController()
    CapsuleButton(style: .expand(isExpanded: false))
//    CapsuleButton(style: .normal)
}
