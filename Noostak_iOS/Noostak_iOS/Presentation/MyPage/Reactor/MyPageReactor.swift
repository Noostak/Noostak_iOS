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
        case tapLogoutConfirm
        case tapWithdrawConfirm
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
            OverlayManager.shared.showPopup(
                contentViewController: .init(
                    popUpView: .init(
                        message: "로그아웃하시겠습니까?",
                        primaryTitle: "로그아웃",
                        secondaryTitle: "취소",
                        primaryAction: { [weak self] in self?.action.onNext(.tapLogoutConfirm) },
                        secondaryAction: nil
                    )
                )
            )
            
            return .empty()
            
        case .tapLogoutConfirm:
            OverlayManager.shared.showToast(toastView: .init(status: .default(message: "로그아웃이 완료되었습니다")))
            return .empty()
            
        case .tapWithdrawItem:
            OverlayManager.shared.showPopup(
                contentViewController: .init(
                    popUpView: .init(
                        message: "회원 탈퇴 시 복구가 불가해요.\n정말 탈퇴하시겠어요?",
                        primaryTitle: "탈퇴하기",
                        secondaryTitle: "취소",
                        primaryAction: { [weak self] in self?.action.onNext(.tapWithdrawConfirm) },
                        secondaryAction: nil
                    )
                )
            )
            return .empty()
            
        case .tapWithdrawConfirm:
            OverlayManager.shared.showToast(toastView: .init(status: .default(message: "회원탈퇴가 완료되었습니다")))
            return .empty()
        }
    }
}
