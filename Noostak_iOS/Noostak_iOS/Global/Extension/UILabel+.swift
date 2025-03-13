//
//  UILabel+.swift
//  Noostak_iOS
//
//  Created by 이명진 on 3/12/25.
//

import RxSwift
import RxCocoa
import UIKit

/// 버튼이 아닌 Label tap했을때 Reactive 입니다.
/// label.rx.tap 으로 이벤트 방출
/// 터치가 끝났을 때, 이벤트를 방출해 줍니다.
extension Reactive where Base: UILabel {
    var tap: ControlEvent<Void> {
        let tapGesture = UITapGestureRecognizer()
        base.addGestureRecognizer(tapGesture)
        base.isUserInteractionEnabled = true
        let source = tapGesture.rx.event
            .filter { $0.state == .ended }  // 터치가 끝났을 때만 이벤트 방출
            .map { _ in }
        return ControlEvent(events: source)
    }
}
