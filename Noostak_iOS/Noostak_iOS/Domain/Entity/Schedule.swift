//
//  Schedule.swift
//  Noostak_iOS
//
//  Created by 오연서 on 1/5/25.
//

import UIKit

enum ScheduleCategory: String {
    ///중요
    case important
    ///일정
    case schedule
    ///취미
    case hobby
    ///기타
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
    let dates: [Date]
    ///약속생성 시작일
    var startDate: Date? {
        return dates.sorted().first
    }
    ///약속생성 종료일
    var endDate: Date? {
        return dates.sorted().last
    }
    ///약속 시작시각
    let startTime: Date
    ///약속 종료시각
    let endTime: Date
    ///소요시간
    var duration: Int?
}

struct ExtendedSchedule {
    ///스케쥴
    let schedule: Schedule
    ///가능한 친구
    let availableMembers: [User]
    ///불가능한 친구
    let unavailableMembers: [User]
}
