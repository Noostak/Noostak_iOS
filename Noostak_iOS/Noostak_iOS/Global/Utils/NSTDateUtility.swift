//
//  NSTDateUtility.swift
//  Noostak_iOS
//
//  Created by 이명진 on 1/7/25.
//

import Foundation

public final class NSTDateUtility {
    
    private static var cache: [String: DateFormatter] = [:]
    private static let lock = NSLock()
    
    private let formatter: DateFormatter
    
    init(format: NSTDateFormatter) {
        let formatString = format.format
        
        NSTDateUtility.lock.lock()
        defer { NSTDateUtility.lock.unlock() }
        
        // Cache에 있으면
        if let cachedFormatter = NSTDateUtility.cache[formatString] {
            formatter = cachedFormatter
        } else {
            formatter = DateFormatter()
            formatter.dateFormat = formatString
            formatter.locale = Locale(identifier: "ko_KO")
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")!
            NSTDateUtility.cache[formatString] = formatter
        }
    }
    
    func date(from string: String) -> Result<Date, NSTError> {
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

public extension NSTDateUtility {
    enum NSTDateFormatter {
        case yyyyMMddTHHmmss
        case yyyyMMddHHmmss
        case yyyyMMdd
        case yyyyMM
        case EE
        case HH
        case HHmm
        case EEMMdd
        case MMddEE
        
        var format: String {
            switch self {
            case .yyyyMMddTHHmmss:
                return "yyyy-MM-dd'T'HH:mm:ss"
            case .yyyyMMddHHmmss:
                return "yyyy-MM-dd HH:mm:ss"
            case .yyyyMMdd:
                return "yyyy-MM-dd"
            case .yyyyMM:
                return "yyyy-MM"
            case .EE:
                return "EE"
            }
        }
    }
    
    enum NSTError: Error {
        case stringDateFormatError
        
        var localizedDescription: String {
            switch self {
            case .stringDateFormatError:
                return "String -> Date 로 변경할때 지정한 포맷과 String 포맷이 다릅니다."
            }
        }
    }
}
