//
//  User.swift
//  
//
//  Created by 오연서 on 1/5/25.
//

struct User {
    ///유저 이름
    let name: String
    ///유저 프로필사진
    let userImage: String?
}

struct UserToken {
    ///액세스토큰
    let accessToken: String
    ///리프레쉬토큰
    let refreshToken: String
}
