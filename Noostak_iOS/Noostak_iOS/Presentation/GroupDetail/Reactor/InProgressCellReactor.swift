//
//  InProgressCellReactor.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/3/25.
//

import ReactorKit
import RxSwift

final class InProgressCellReactor: Reactor {
    typealias Action = NoAction
    struct State {
        let schedule: ExtendedSchedule
    }
    
    let initialState: State

    init(schedule: ExtendedSchedule) {
        self.initialState = State(schedule: schedule)
    }
}
