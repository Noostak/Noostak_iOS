//
//  NTDateUtility.swift
//  Noostak_iOS
//
//  Created by 이명진 on 1/7/25.
//

import Foundation

enum NTError: Error {
    case stringDateFormatError // String -> Date 로 변경할때 지정한 포맷과 String 포맷이 다릅니다.
}

public enum NTDateFormatter {
    case yyyyMMddHHmmss
    case yyyyMMdd
    case yyyyMM
    
    var format: String {
        switch self {
        case .yyyyMMddHHmmss:
            return "yyyy-MM-dd HH:mm:ss"
        case .yyyyMMdd:
            return "yyyy-MM-dd"
        case .yyyyMM:
            return "yyyy-MM"
        }
    }
}

public final class NTDateUtility {
    
    private static var cache: [String: DateFormatter] = [:]
    private static let lock = NSLock()
    
    private let formatter: DateFormatter
    
    init(format: NTDateFormatter) {
        let formatString = format.format
        
        NTDateUtility.lock.lock()
        defer { NTDateUtility.lock.unlock() }
        
        // Cache에 있으면
        if let cachedFormatter = NTDateUtility.cache[formatString] {
            formatter = cachedFormatter
        } else {
            formatter = DateFormatter()
            formatter.dateFormat = formatString
            formatter.locale = Locale(identifier: "ko_KO")
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")!
            NTDateUtility.cache[formatString] = formatter
        }
    }
    
    func date(from string: String) -> Result<Date, NTError> {
        if let date = formatter.date(from: string) {
            return .success(date)
        } else {
            return .failure(.stringDateFormatError)
        }
    }
    
    func string(from date: Date) -> String {
        formatter.string(from: date)
    }
}
