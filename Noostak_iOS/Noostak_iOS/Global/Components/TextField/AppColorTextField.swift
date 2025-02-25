//
//  AppColorTextField.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/7/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

enum TextFieldState: Equatable {
    case valid
    case invalid(String?)
}

final class AppColorTextField: UIView {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let internalTextRelay: BehaviorRelay<String> = .init(value: "")
    private let internalStateRelay: BehaviorRelay<TextFieldState> = .init(value: .valid)
    private let focusStateRelay: BehaviorRelay<Bool> = .init(value: false)
    private var countLimit: Int?
    
    // MARK: Views
    private let textField = UITextField()
    private let deleteButton = UIButton()
    private let alertLabel = UILabel()
    private let countLabel = UILabel()
    private lazy var textFieldContainer = UIStackView(arrangedSubviews: [textField, deleteButton])
    private lazy var footerContainer = UIStackView(arrangedSubviews: [alertLabel, UIView(), countLabel])
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    init(placeholder: String? = nil, countLimit: Int? = nil, activateDeleteButton: Bool = false) {
        self.countLimit = countLimit
        super.init(frame: .zero)
        if let placeholder {
            textField.setPlaceholder(
                text: placeholder,
                color: .appGray600,
                font: .PretendardStyle.b5_r.font
            )
        }
        if let countLimit { setCountLabelBinding(limit: countLimit) }
        if activateDeleteButton { setDeleteButton() }
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
            textFieldContainer,
            footerContainer
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        textField.do {
            $0.font = .PretendardStyle.b5_r.font
            $0.textColor = .appBlack
            $0.borderStyle = .none
        }
        
        deleteButton.do {
            $0.setImage(.icnTextfieldDelete24, for: .normal)
            $0.isHidden = true
        }
        
        textFieldContainer.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .fill
            $0.distribution = .fill
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.appGray700.cgColor
            $0.layer.masksToBounds = true
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        
        countLabel.do {
            $0.font = .PretendardStyle.c3_r.font
            $0.textColor = .appGray800
        }
        
        alertLabel.do {
            $0.font = .PretendardStyle.c3_sb.font
            $0.textColor = .clear
        }
        
        footerContainer.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
            $0.isUserInteractionEnabled = false
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        textFieldContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        footerContainer.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(textFieldContainer.snp.bottom).offset(6)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(76)
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
                self?.focusStateRelay.accept(true)
            })
            .disposed(by: disposeBag)
        
        // Unfocus 상태 감지
        textField.rx.controlEvent([.editingDidEnd])
            .subscribe(onNext: { [weak self] in
                self?.focusStateRelay.accept(false)
            })
            .disposed(by: disposeBag)
        
        // 상태 변화에 따른 UI 업데이트
        Observable.combineLatest(stateRelay, focusStateRelay) { return ($0, $1) }
        .bind { [weak self] state, focused in
            self?.updateUI(for: state, focused: focused)
        }
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
    
    private func setDeleteButton() {
        textRelay
            .distinctUntilChanged()
            .bind { [weak self] in
                self?.deleteButton.isHidden = $0.isEmpty
            }
            .disposed(by: disposeBag)
    }
    
    private func updateUI(for state: TextFieldState, focused: Bool) {
        switch state {
        case .valid:
            textFieldContainer.layer.borderColor = focused
            ? UIColor.appBlue600.cgColor
            : UIColor.appGray700.cgColor
            alertLabel.isHidden = true
            
        case .invalid(let errorMessage):
            textFieldContainer.layer.borderColor = UIColor.appRed02.cgColor
            alertLabel.isHidden = false
            alertLabel.text = errorMessage ?? "입력값이 올바르지 않습니다."
            alertLabel.textColor = .appRed02
        }
    }
}

// MARK: Interface
extension AppColorTextField {
    var stateRelay: BehaviorRelay<TextFieldState> {
        return self.internalStateRelay
    }
    
    var deleteButtonTapped: ControlEvent<Void> {
        return self.deleteButton.rx.tap
    }
}

extension AppColorTextField: AppTextFieldProtocol {
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

// MARK: Rx Extension
extension Reactive where Base: AppColorTextField {
    var state: ControlProperty<TextFieldState> {
        let stateRelay = base.stateRelay

        return ControlProperty(
            values: stateRelay.asObservable(),
            valueSink: Binder(base) { textField, state in
                textField.stateRelay.accept(state)
            }
        )
    }
    
    var deleteButtonTapped: ControlEvent<Void> {
        return base.deleteButtonTapped
    }
}
