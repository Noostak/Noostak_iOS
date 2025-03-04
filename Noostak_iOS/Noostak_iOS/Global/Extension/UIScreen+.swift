//
//  UIScreen+.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/26/25.
//

import UIKit

public extension UIScreen {
    /// 상단 safeArea
    static var safeAreaTop: CGFloat {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first else { return 0 }
        
        let topInset = window.safeAreaInsets.top
        return topInset > 0 ? topInset : 0
    }
    
    /// 하단 safeArea
    static var safeAreaBottom: CGFloat {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first else { return 0 }
        
        let bottomInset = window.safeAreaInsets.bottom
        return bottomInset > 0 ? bottomInset : 0
    }
}
