//
//  String+.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/4/25.
//

import UIKit

extension String {
    /// Pretendard 스타일로 NSAttributedString 생성
    ///
    /// - Parameters:
    ///   - style: Pretendard 스타일 (e.g., `.h1_b`, `.h2_b`)
    ///
    /// - Returns: NSAttributedString으로 반환된 텍스트
    ///
    /// - Usage:
    /// ```swift
    /// let styledText = "Custom Styled Text".pretendardStyled(style: .h1_b)
    /// label.attributedText = styledText
    /// ```
    func pretendardStyled(style: UIFont.PretendardStyle) -> NSAttributedString {
        let font = style.font
        let lineHeight = font.pointSize * style.lineHeightUnit / 100
        let letterSpacing = style.letterSpacingUnit

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.appGray800.cgColor,
            .paragraphStyle: paragraphStyle,
            .kern: letterSpacing
        ]

        return NSAttributedString(string: self, attributes: attributes)
    }
}
