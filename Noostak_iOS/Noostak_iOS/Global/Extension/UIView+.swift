//
//  UIView+.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/8/25.
//

import UIKit

extension UIView {
    /// 뷰를 원형으로 만드는 메서드
    func makeCircular() {
        self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
        self.layer.masksToBounds = true
    }
}
