//
//  SignUpValidator.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/20/25.
//

import Foundation

struct SignUpValidator {
    static func validate(name: String) -> ValidationResult {
            // 1. 글자 수 제한 (1~10자)
            guard (1...10).contains(name.count) else {
                return .invalid(reason: "이름은 1~10자로 입력해야 합니다.")
            }

            // 2. 허용 문자: 영어 대소문자, 숫자, 한글, 홀자(한자)
            let regex = "^[A-Za-z0-9가-힣]*$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)

            if !predicate.evaluate(with: name) {
                return .invalid(reason: "띄어쓰기 및 특수문자는 사용할 수 없습니다.")
            }

            return .valid
        }
}
