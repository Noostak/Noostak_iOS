//
//  Group.swift
//  Noostak_iOS
//
//  Created by 오연서 on 1/5/25.
//

import UIKit

struct Group {
    ///그룹 id
    let id: Int
    ///그룹 이룸
    let name: String
    ///그룹 코드
    let code: String
    ///그룹 멤버수
    let membersCount: Int
    ///방장
    let leader: User
    ///멤버
    let members: [User]
}
