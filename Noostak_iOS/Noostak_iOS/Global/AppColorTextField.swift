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

final class AppColorTextField: UIView {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let internalTextRelay: BehaviorRelay<String> = .init(value: "")
    private var countLimit: Int?
    
    // MARK: Views
    private let textField = PaddedTextField(padding: .init(top: 15, left: 12, bottom: 15, right: 12))
    private let countLabel = UILabel()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    init(placeholder: String? = nil, countLimit: Int? = nil) {
        self.countLimit = countLimit
        super.init(frame: .zero)
        if let placeholder {
            textField.setPlaceholder(
                text: placeholder,
                color: .appGray500,
                font: .PretendardStyle.b1_sb.font
            )
        }
        if let countLimit { setCountLabelBinding(limit: countLimit) }
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
            countLabel
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        textField.do {
            $0.font = .PretendardStyle.b1_sb.font
            $0.textColor = .appGray900
            $0.borderStyle = .roundedRect
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.appGray200.cgColor
        }
        
        countLabel.do {
            $0.font = .PretendardStyle.b5_r.font
            $0.textColor = .appGray500
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
    }
    
    private func bind() {
        // Text 바인딩
        textField.rx.text.orEmpty
            .bind(to: textRelay)
            .disposed(by: disposeBag)
        
        // Focus 상태 감지
        textField.rx.controlEvent([.editingDidBegin])
            .subscribe(onNext: { [weak self] in
                self?.setUIColor(isFocused: true)
            })
            .disposed(by: disposeBag)
        
        // Unfocus 상태 감지
        textField.rx.controlEvent([.editingDidEnd])
            .subscribe(onNext: { [weak self] in
                self?.setUIColor(isFocused: false)
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
    
    private func setUIColor(isFocused: Bool) {
        if isFocused {
            textField.layer.borderColor = UIColor.appBlue600.cgColor
        } else {
            let borderColor = textRelay.value.isEmpty ? UIColor.appGray200 : UIColor.appGray500
            textField.layer.borderColor = borderColor.cgColor
        }
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

class ex2: UIViewController {
    let textField = AppColorTextField(placeholder: "이름을 입력해주세요.", countLimit: 20)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textField)
        
        textField.textRelay.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        textField.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(343)
        }

        setupDismissKeyboardOnTap()
    }
    
    private func setupDismissKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        textField.resignFirstResponder()
    }
}
