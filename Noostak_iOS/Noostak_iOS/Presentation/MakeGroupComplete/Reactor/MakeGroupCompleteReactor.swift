//
//  MakeGroupCompleteReactor.swift
//  Noostak_iOS
//
//  Created by 박민서 on 3/1/25.
//

import RxSwift
import ReactorKit
import UIKit

final class MakeGroupCompleteReactor: Reactor {
    enum Action {
        case tapCopyGroupCodeButton
        case tapSendGroupCodeButton(vc: UIViewController)
        case tapDismissButton
    }
    
    enum Mutation {}
    
    struct State {
        var groupCode: String
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapCopyGroupCodeButton:
            UIPasteboard.general.string = currentState.groupCode
            OverlayManager.shared.showToast(toastView: .init(status: .default(message: "코드가 복사되었습니다")))
            return .empty()
            
        case .tapSendGroupCodeButton(let vc):
            print("코드 보내기 - 공유창 열기")
            SharePresenter.share(items: [currentState.groupCode], from: vc, completion: {_ in })
            return .empty()
            
        case .tapDismissButton:
            print("닫기")
            return .empty()
        }
    }
}
