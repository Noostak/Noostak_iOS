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
    ///   - color: 적용할 텍스트 색상 (기본값: `.appGray800`)
    ///
    /// - Returns: NSAttributedString으로 반환된 텍스트
    ///
    /// - Usage:
    /// ```swift
    /// let styledText = "Custom Styled Text".pretendardStyled(style: .h1_b, color: .red)
    /// label.attributedText = styledText
    /// ```
    func pretendardStyled(style: UIFont.PretendardStyle, color: UIColor = .appGray800) -> NSAttributedString {
        let font = style.font
        let lineHeight = font.pointSize * style.lineHeightUnit / 100
        let letterSpacing = style.letterSpacingUnit

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle,
            .kern: letterSpacing
        ]

        return NSAttributedString(string: self, attributes: attributes)
    }
}
