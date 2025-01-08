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
