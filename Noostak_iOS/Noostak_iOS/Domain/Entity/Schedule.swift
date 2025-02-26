//
//  Schedule.swift
//  Noostak_iOS
//
//  Created by 오연서 on 1/5/25.
//

import UIKit

enum ScheduleCategory: String, CaseIterable {
    case important
    case schedule
    case hobby
    case other
}

struct Schedule {
    ///약속 id
    let id: Int
    ///약속 이름
    let name: String
    ///약속 카테고리
    let category: ScheduleCategory
    ///약속 생성기간
    let selectionDates: [Date]
    ///약속생성 시작일
    var selectionStartDate: Date? {
        return selectionDates.sorted().first
    }
    ///약속생성 종료일
    var selectionEndDate: Date? {
        return selectionDates.sorted().last
    }
    ///약속생성 시작시각
    let selectionStartTime: Date
    ///약속생성 종료시각
    let selectionEndTime: Date
    ///소요시간
    var duration: Int?
}

struct ExtendedSchedule {
    ///스케쥴
    let schedule: Schedule
    ///약속 날짜(1순위, 확정)
    let date: String
    ///약속 시작시각(1순위, 확정)
    let startTime: String
    ///약속 종료시각(1순위, 확정)
    let endTime: String
    ///나의 가능 여부
    let myInfo: MemberStatus
    ///가능한 친구
    let availableMembers: [User]
    ///불가능한 친구
    let unavailableMembers: [User]
    ///그룹 총인원
    var groupMemberCount: Int
    ///가능한 인원
    var availableMemberCount: Int
}

extension ScheduleCategory {
    /// 한글명 반환
    var name: String {
        switch self {
        case .important:
            return "중요"
        case .schedule:
            return "일정"
        case .hobby:
            return "취미"
        case .other:
            return "기타"
        }
    }
    
    /// 색상 반환
    var displayColor: UIColor {
        switch self {
        case .important:
            return .appOrange
        case .schedule:
            return .appBlue
        case .hobby:
            return .appPurple
        case .other:
            return .appMint
        }
    }
}
