//
//  UIViewController+.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/25/25.
//

import UIKit

extension UIViewController {
    /// 화면을 탭하면 키보드를 내리는 기능을 추가하는 메서드
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
