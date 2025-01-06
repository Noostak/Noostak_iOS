//
//  AppTextFieldProtocol.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/7/25.
//

import UIKit
import RxRelay

protocol AppTextFieldProtocol: UIView {
    /// 텍스트 필드 텍스트 상태
    var textRelay: BehaviorRelay<String> { get }
    /// 텍스트 필드 포커스 되었는지
    var isFocused: Bool { get }
    /// 텍스트 필드 포커스하기
    /// true if this object is now the first responder; otherwise, false.
    @discardableResult
    func becomeFirstResponder() -> Bool
    /// 텍스트 필드 포커스 해제하기
    /// true if this object is now the first responder; otherwise, false.
    @discardableResult
    func resignFirstResponder() -> Bool
}
