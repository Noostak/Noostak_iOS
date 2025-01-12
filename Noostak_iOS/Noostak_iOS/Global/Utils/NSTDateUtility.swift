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
            case .HH:
                return "HH"
            case .MMddEE:
                return "EE\nMM/dd"
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

func dateList(_ dateStrings: [String]) -> [String] {
    let formatter = NSTDateUtility(format: .yyyyMMddTHHmmss) // ISO 8601 형식
    let displayFormatter = NSTDateUtility(format: .MMddEE) // 출력 형식
    
    return dateStrings.compactMap { dateString in
        switch formatter.date(from: dateString) {
        case .success(let date):
            return displayFormatter.string(from: date)
        case .failure(let error):
            print("Failed to parse date \(dateString): \(error.localizedDescription)")
            return nil
        }
    }
}

func timeList(_ startTime: String, _ endTime: String) -> [String] {
    let formatter = NSTDateUtility(format: .yyyyMMddTHHmmss) // ISO 8601 형식
    var result: [String] = []
    
    switch (formatter.date(from: startTime), formatter.date(from: endTime)) {
    case (.success(let start), .success(let end)):
        let calendar = Calendar.current
        var current = start
        
        while current <= end {
            result.append(NSTDateUtility(format: .HH).string(from: current)) // 출력 형식
            if let nextHour = calendar.date(byAdding: .hour, value: 1, to: current) {
                current = nextHour
            } else {
                break
            }
        }
    default:
        print("Failed to parse start or end time.")
        return []
    }
    return result
}
