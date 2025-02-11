//
//  GroupMemberCellReactor.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/9/25.
//

import ReactorKit
import RxSwift

final class GroupMemberCellReactor: Reactor {
    typealias Action = NoAction
    struct State {
        let user: User
    }
    
    let initialState: State
    
    init(user: User) {
        self.initialState = State(user: user)
    }
}

let mockMemberData = Group(id: 1,
                           name: "누트탁",
                           code: "AKFJS",
                           membersCount: 10,
                           groupImage: "df",
                           host: User(name: "오연서", userImage: "1"),
                           members: [
                            User(name: "오연서", userImage: "1"),
                            User(name: "오옹서", userImage: "1"),
                            User(name: "오앵서", userImage: "1"),
                            User(name: "오용서", userImage: "1"),
                            User(name: "오잉서", userImage: "1"),
                            User(name: "오옹서", userImage: "1"),
                            User(name: "오앵서", userImage: "1"),
                            User(name: "오용아", userImage: "1"),
                            User(name: "오러서", userImage: "1"),
                            User(name: "오엉서", userImage: "1")]
)
