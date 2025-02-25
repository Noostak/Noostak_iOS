//
//  SignUpCompleteReactor.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/25/25.
//

import RxSwift
import ReactorKit

final class SignUpCompleteReactor: Reactor {
    enum Action {
        case tapNoGroupButton
        case tapEnterGroupCodeButton
    }
    
    enum Mutation {}
    
    struct State {
        var name: String
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapNoGroupButton:
            print("홈 화면으로 이동")
            return .empty()
            
        case .tapEnterGroupCodeButton:
            print("그룹 코드 입력 화면으로 이동")
            return .empty()
        }
    }
}
