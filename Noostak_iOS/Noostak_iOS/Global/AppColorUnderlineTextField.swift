//
//  AppColorUnderlineTextField.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/7/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class AppColorUnderlineTextField: UIView {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let internalTextRelay: BehaviorRelay<String> = .init(value: "")
    private var countLimit: Int?
    
    // MARK: Views
    private let textField = PaddedTextField(padding: .init(top: 15, left: 10, bottom: 15, right: 10))
    private let typeLabel = UILabel()
    private let underLine = UIView()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    init(placeholder: String? = nil, typeString: String? = nil) {
        super.init(frame: .zero)
        if let placeholder { textField.setPlaceholder(text: placeholder) }
        if let typeString { typeLabel.text = typeString }
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
            underLine,
            textField,
            typeLabel
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        textField.do {
            $0.font = .PretendardStyle.b1_sb.font
            $0.textAlignment = .right
        }
        
        typeLabel.do {
            $0.font = .PretendardStyle.b1_sb.font
            $0.textColor = .appGray700
        }
        
        underLine.do {
            $0.backgroundColor = .appGray200
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        textField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.equalTo(typeLabel).inset(18)
            $0.height.equalTo(52)
        }
        
        typeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalTo(textField)
        }
        
        underLine.snp.makeConstraints {
            $0.bottom.equalTo(textField.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(2)
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
    
    private func setUIColor(isFocused: Bool) {
        if isFocused {
            underLine.backgroundColor = UIColor.appBlue600
        } else {
            let textColor = textRelay.value.isEmpty ? UIColor.appGray200 : UIColor.appGray500
            underLine.backgroundColor = textColor
        }
    }
}

extension AppColorUnderlineTextField: AppTextFieldProtocol {
    
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

class ex3: UIViewController {
    let textField = AppColorUnderlineTextField(typeString: "시간")
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
