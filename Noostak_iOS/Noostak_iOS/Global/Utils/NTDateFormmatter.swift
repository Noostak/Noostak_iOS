//
//  NTDateFormmatter.swift
//  Noostak_iOS
//
//  Created by 이명진 on 1/7/25.
//

import Foundation

public enum NTDateFormatter {
    case yyyyMMdd
    case yyyyMM
    case yyyyMMddHHmmss
    
    var format: String {
        switch self {
        case .yyyyMMdd: return "yyyy-MM-dd"
        case .yyyyMM: return "yyyy-MM"
        case .yyyyMMddHHmmss: return "yyyy-MM-dd HH:mm:ss"
        }
    }
}

enum NTError: Error {
    case stringDateFormatError // String -> Date 로 변경할때 지정한 포맷과 String 포맷이 다릅니다.
}
