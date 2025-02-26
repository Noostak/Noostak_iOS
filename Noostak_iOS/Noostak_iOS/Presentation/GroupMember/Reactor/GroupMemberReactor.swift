//
//  GroupMemberReactor.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/9/25.
//

import ReactorKit
import RxSwift
import RxDataSources

final class GroupMemberReactor: Reactor {
    enum Action {
        case loadGroupData
    }
    
    enum Mutation {
        case setGroup(Group)
    }
    
    struct State {
        var group: Group
    }
    
    let initialState: State
    
    init() {
        self.initialState = State(group: mockMemberData)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadGroupData:
            return Observable.just(.setGroup(currentState.group))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setGroup(let group):
            newState.group = group
        }
        return newState
    }
}
