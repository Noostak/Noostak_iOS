//
//  AppTextField.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/6/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

protocol AppTextFieldProtocol: UIView {
    /// 텍스트 필드 텍스트 상태
    var textRelay: BehaviorRelay<String> { get }
    /// 텍스트 필드 포커스 되었는지
    var isFocused: Bool { get }
    /// 텍스트 필드 포커스하기
    func becomeFirstResponder() -> Bool
    /// 텍스트 필드 포커스 해제하기
    func resignFirstResponder() -> Bool
}

final class AppGrayTextField: UIView {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    let textRelay: BehaviorRelay<String> = .init(value: "")
    private var countLimit: Int?
    
    // MARK: Views
    private let textField = UITextField()
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
            .bind(to: textRelay)
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
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }
    
    override var isFocused: Bool {
        return textField.isFirstResponder
    }
}

class ex: UIViewController {
    let textField = AppGrayTextField(
        placeholder: "이름을 입력해주세요.",
        countLimit: 30,
        exampleText: "예) 홍길동"
    )
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textField)
        
        textField.textRelay.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        textField.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(343)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.textField.resignFirstResponder() // 5초 뒤 포커스 해제
        }
    }
}

#Preview {
    ex()
}
