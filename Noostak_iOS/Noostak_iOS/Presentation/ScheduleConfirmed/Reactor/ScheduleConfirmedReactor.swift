//
//  ScheduleConfirmedReactor.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/11/25.
//

import ReactorKit
import RxSwift

final class ScheduleConfirmedReactor: Reactor {
    enum Action {
        case loadSchedule
    }
    
    enum Mutation {
        case setSchedule(ExtendedSchedule)
    }
    
    struct State {
        var schedule: ExtendedSchedule
        var myInfo: MemberStatus
        var availableMembers: [User]
        var unavailableMembers: [User]
    }
    
    let initialState: State
    
    init() {
        self.initialState = State(schedule: mockExtendedSchedule,
                                  myInfo: mockExtendedSchedule.myInfo,
                                  availableMembers: mockExtendedSchedule.availableMembers,
                                  unavailableMembers: mockExtendedSchedule.unavailableMembers)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadSchedule:
            return Observable.just(.setSchedule(initialState.schedule))
        }
        
        func reduce(state: State, mutation: Mutation) -> State {
            var newState = state
            switch mutation {
            case .setSchedule(let schedule):
                newState.schedule = schedule
                newState.myInfo = schedule.myInfo
                newState.availableMembers = schedule.availableMembers
                newState.unavailableMembers = schedule.unavailableMembers
            }
            return newState
        }
    }
}
