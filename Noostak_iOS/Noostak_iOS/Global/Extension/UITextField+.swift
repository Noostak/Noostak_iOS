//
//  UITextField+.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/7/25.
//

import UIKit

extension UITextField {
    func setPlaceholder(text: String?, color: UIColor = .appGray600, font: UIFont = UIFont.PretendardStyle.b5_r.font) {
        guard let text else {
            self.placeholder = nil
            return
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: font
        ]
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
    }
}
