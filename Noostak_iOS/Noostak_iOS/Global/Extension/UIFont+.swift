//
//  UIFont+.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/4/25.
//

import UIKit

extension UIFont {
    enum Pretendard {
        case thin
        case extraLight
        case light
        case regular
        case medium
        case semibold
        case bold
        case extrabold
        case black
        
        var name: String {
            switch self {
            case .thin: return "Pretendard-Thin"
            case .extraLight: return "Pretendard-ExtraLight"
            case .light: return "Pretendard-Light"
            case .regular: return "Pretendard-Regular"
            case .medium: return "Pretendard-Medium"
            case .semibold: return "Pretendard-SemiBold"
            case .bold: return "Pretendard-Bold"
            case .extrabold: return "Pretendard-ExtraBold"
            case .black: return "Pretendard-Black"
            }
        }
    }
    
    /// Custom Pretendard 폰트를 생성하는 메서드
    static func pretendard(_ weight: Pretendard, size: CGFloat) -> UIFont {
        return UIFont(name: weight.name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

extension UIFont {
    enum PretendardStyle {
        case h1_b
        case h1_sb
        case h2_b
        case h3_sb
        case h4_b
        case h4_sb
        case h5_b
        case t1_sb
        case t2_r
        case t3_b
        case t4_b
        case b1_sb
        case b2_r
        case b4_sb
        case b4_sb_1percent
        case b4_r
        case b5_r
        case c1_b
        case c2_sb
        case c3_r
        case c4_r

        var font: UIFont {
            switch self {
            case .h1_b: return UIFont.pretendard(.bold, size: 56)
            case .h1_sb: return UIFont.pretendard(.semibold, size: 56)
            case .h2_b: return UIFont.pretendard(.bold, size: 27)
            case .h3_sb: return UIFont.pretendard(.semibold, size: 24)
            case .h4_b: return UIFont.pretendard(.bold, size: 24)
            case .h4_sb: return UIFont.pretendard(.semibold, size: 20)
            case .h5_b: return UIFont.pretendard(.bold, size: 18)
            case .t1_sb: return UIFont.pretendard(.semibold, size: 18)
            case .t2_r: return UIFont.pretendard(.regular, size: 18)
            case .t3_b: return UIFont.pretendard(.bold, size: 17)
            case .t4_b: return UIFont.pretendard(.bold, size: 16)
            case .b1_sb: return UIFont.pretendard(.semibold, size: 16)
            case .b2_r: return UIFont.pretendard(.regular, size: 16)
            case .b4_sb: return UIFont.pretendard(.semibold, size: 15)
            case .b4_sb_1percent: return UIFont.pretendard(.semibold, size: 15)
            case .b4_r: return UIFont.pretendard(.regular, size: 15)
            case .b5_r: return UIFont.pretendard(.regular, size: 14)
            case .c1_b: return UIFont.pretendard(.bold, size: 13)
            case .c2_sb: return UIFont.pretendard(.semibold, size: 13)
            case .c3_r: return UIFont.pretendard(.regular, size: 13)
            case .c4_r: return UIFont.pretendard(.regular, size: 11)
            }
        }

        // Line Height (LHLHUnit)
        var lineHeightUnit: CGFloat {
            switch self {
            case .h1_b, .h1_sb, .h2_b, .h3_sb, .h4_b, .h4_sb, .h5_b,
                 .t1_sb, .t2_r, .t3_b, .t4_b, .b1_sb, .b2_r, .b4_sb,
                 .b4_sb_1percent, .b4_r, .b5_r, .c1_b, .c2_sb, .c3_r, .c4_r:
                return 140
            }
        }

        // Letter Spacing (LSLSUnit)
        var letterSpacingUnit: CGFloat {
            switch self {
            case .h1_b: return 10
            default: return 0
            }
        }
    }
}
