//
//  MemberAvailabilityCellReactor.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/11/25.
//

import ReactorKit
import RxSwift

final class MemberAvailabilityCellReactor: Reactor {
    typealias Action = NoAction
    struct State {
        let user: User
        let status: MemberStatus
    }
    
    let initialState: State
    
    init(user: User, status: MemberStatus) {
        self.initialState = State(user: user, status: status)
    }
}
