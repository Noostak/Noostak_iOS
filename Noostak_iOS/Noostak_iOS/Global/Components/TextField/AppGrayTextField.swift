//
//  AppGrayTextField.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/6/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class AppGrayTextField: UIView {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let internalTextRelay: BehaviorRelay<String> = .init(value: "")
    private var countLimit: Int?
    
    // MARK: Views
    private let textField = PaddedTextField(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    private let countLabel = UILabel()
    private let exampleLabel = UILabel()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    init(placeholder: String? = nil, countLimit: Int? = nil, exampleText: String? = nil) {
        self.countLimit = countLimit
        super.init(frame: .zero)
        if let placeholder { textField.setPlaceholder(text: placeholder) }
        if let countLimit { setCountLabelBinding(limit: countLimit) }
        if let exampleText { exampleLabel.attributedText = exampleText.pretendardStyled(style: .b5_r) }
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            textField,
            countLabel,
            exampleLabel
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        textField.do {
            $0.font = .PretendardStyle.b5_r.font
            $0.clearButtonMode = .whileEditing
            $0.clearButtonRect(forBounds: .init(x: 0, y: 0, width: 20, height: 20))
            $0.borderStyle = .roundedRect
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.appGray500.cgColor
        }
        
        countLabel.do {
            $0.font = .PretendardStyle.b5_r.font
            $0.textColor = .appGray800
        }
        
        exampleLabel.do {
            $0.font = .PretendardStyle.b5_r.font
            $0.textColor = .appGray800
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        textField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        countLabel.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.top.equalTo(textField.snp.bottom).offset(6)
        }
        
        exampleLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.top.equalTo(textField.snp.bottom).offset(6)
        }
    }
    
    private func bind() {
        // Text 바인딩
        textField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: textRelay)
            .disposed(by: disposeBag)
        
        // textRelay 값이 변경되면 textField에도 반영
        textRelay
            .distinctUntilChanged()
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        
        // Focus 상태 감지
        textField.rx.controlEvent([.editingDidBegin])
            .subscribe(onNext: { [weak self] in
                self?.textField.layer.borderColor = UIColor.appGray900.cgColor
            })
            .disposed(by: disposeBag)
        
        // Unfocus 상태 감지
        textField.rx.controlEvent([.editingDidEnd])
            .subscribe(onNext: { [weak self] in
                self?.textField.layer.borderColor = UIColor.appGray500.cgColor
            })
            .disposed(by: disposeBag)
    }
    
    private func setCountLabelBinding(limit: Int) {
        // CountLimit 존재하는 경우에만 우측 하단에 라벨 바인딩
        textRelay
            .distinctUntilChanged()
            .map { "\($0.count)/\(limit)"}
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension AppGrayTextField: AppTextFieldProtocol {
    
    var textRelay: BehaviorRelay<String> {
        return self.internalTextRelay
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }
    
    override var isFocused: Bool {
        return textField.isFirstResponder
    }
}
