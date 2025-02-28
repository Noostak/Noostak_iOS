//
//  MyPageReactor.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/28/25.
//

import RxSwift
import ReactorKit

final class MyPageReactor: Reactor {
    enum Action {
        case tapProfileEditItem
        case tapTermsItem
        case tapLogoutItem
        case tapWithdrawItem
    }
    
    enum Mutation {}
    
    struct State {
        var imageURL: String = ""
        var name: String = "박민서"
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapProfileEditItem:
            print("프로필 수정 화면으로 이동")
            return .empty()
            
        case .tapTermsItem:
            print("약관 및 정책 화면으로 이동")
            return .empty()
            
        case .tapLogoutItem:
            print("로그아웃 팝업")
            return .empty()
            
        case .tapWithdrawItem:
            print("회원탈퇴 팝업")
            return .empty()
        }
    }
}
