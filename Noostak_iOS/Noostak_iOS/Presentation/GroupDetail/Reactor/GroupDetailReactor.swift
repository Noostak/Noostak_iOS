//
//  GroupDetailReactor.swift
//  Noostak_iOS
//
//  Created by 오연서 on 1/31/25.
//

import ReactorKit
import RxSwift
import UIKit

final class GroupDetailReactor: Reactor {
    enum Action {
        case selectSegment(Int)  // 세그먼트 선택
        case loadInProgressData
        case loadConfirmedData
    }
    enum Mutation {
        case setSelectedSegment(Int)
        case setInProgressData([InProgressCellReactor])
        case setConfirmedData([ConfirmedCellReactor])
    }
    struct State {
        var selectedSegmentIndex: Int = 0
        var inProgressCellReactors: [InProgressCellReactor] = []
        var confirmedCellReactors: [ConfirmedCellReactor] = []
    }
    
    let initialState = State(
        selectedSegmentIndex: 0,
        inProgressCellReactors: mockInProgressData.map { InProgressCellReactor(schedule: $0) },
        confirmedCellReactors: mockConfirmedData.map { ConfirmedCellReactor(schedule: $0) }
    )
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectSegment(let index):
            return Observable.just(.setSelectedSegment(index))
        
        case .loadInProgressData:
            let reactors = mockInProgressData.map { InProgressCellReactor(schedule: $0) }
            return Observable.just(.setInProgressData(reactors))
        
        case .loadConfirmedData:
            let reactors = mockConfirmedData.map { ConfirmedCellReactor(schedule: $0) }
            return Observable.just(.setConfirmedData(reactors))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSelectedSegment(let index):
            newState.selectedSegmentIndex = index
        
        case .setInProgressData(let reactors):
            newState.inProgressCellReactors = reactors
        
        case .setConfirmedData(let reactors):
            newState.confirmedCellReactors = reactors
        }
        return newState
    }
}

let mockInProgressData: [ExtendedSchedule] = [
    ExtendedSchedule(schedule: Schedule(id: 1,
                                        name: "뉴스탹진행중",
                                        category: .hobby,
                                        selectionDates: [],
                                        selectionStartTime: Date(),
                                        selectionEndTime: Date()),
                     date: "2024-09-05T10:00:00",
                     startTime: "2024-09-05T10:00:00",
                     endTime: "2024-09-05T18:00:00",
                     myInfo: .available,
                     availableMembers: [],
                     unavailableMembers: [],
                     groupMemberCount: 24,
                     availableMemberCount: 11),
    ExtendedSchedule(schedule: Schedule(id: 2,
                                        name: "뉴스탹2",
                                        category: .important,
                                        selectionDates: [],
                                        selectionStartTime: Date(),
                                        selectionEndTime: Date()),
                     date: "2024-09-05T10:00:00",
                     startTime: "2024-09-05T10:00:00",
                     endTime: "2024-09-05T18:00:00",
                     myInfo: .available,
                     availableMembers: [],
                     unavailableMembers: [],
                     groupMemberCount: 23,
                     availableMemberCount: 12),
    ExtendedSchedule(schedule: Schedule(id: 1,
                                        name: "뉴스탹3",
                                        category: .hobby,
                                        selectionDates: [],
                                        selectionStartTime: Date(),
                                        selectionEndTime: Date()),
                     date: "2024-09-05T10:00:00",
                     startTime: "2024-09-05T10:00:00",
                     endTime: "2024-09-05T18:00:00",
                     myInfo: .available,
                     availableMembers: [],
                     unavailableMembers: [],
                     groupMemberCount: 24,
                     availableMemberCount: 11)
]
let mockConfirmedData: [ExtendedSchedule] = [
    ExtendedSchedule(schedule: Schedule(id: 1,
                                        name: "뉴스탹유ㅏㄴ",
                                        category: .hobby,
                                        selectionDates: [],
                                        selectionStartTime: Date(),
                                        selectionEndTime: Date()),
                     date: "2024-09-05T10:00:00",
                     startTime: "2024-09-05T10:00:00",
                     endTime: "2024-09-05T18:00:00",
                     myInfo: .available,
                     availableMembers: [],
                     unavailableMembers: [],
                     groupMemberCount: 24,
                     availableMemberCount: 11),
    ExtendedSchedule(schedule: Schedule(id: 2,
                                        name: "뉴스탹2",
                                        category: .important,
                                        selectionDates: [],
                                        selectionStartTime: Date(),
                                        selectionEndTime: Date()),
                     date: "2024-09-05T10:00:00",
                     startTime: "2024-09-05T10:00:00",
                     endTime: "2024-09-05T18:00:00",
                     myInfo: .available,
                     availableMembers: [],
                     unavailableMembers: [],
                     groupMemberCount: 23,
                     availableMemberCount: 12)
]
