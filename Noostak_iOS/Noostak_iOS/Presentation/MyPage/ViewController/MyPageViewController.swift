//
//  MyPageViewController.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/28/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import Kingfisher

final class MyPageViewController: UIViewController, View {
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    // MARK: Views
    private let rootView = MyPageView()
    
    init(reactor: MyPageReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: bind
    func bind(reactor: MyPageReactor) {
        // MARK: Action
        // 사용자의 프로필 수정 버튼 탭
        rootView.profileEditButton.rx.tap
            .map { MyPageReactor.Action.tapProfileEditItem }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 사용자의 약관 및 정책 버튼 탭
        rootView.termsItem.rightButton.rx.tap
            .map { MyPageReactor.Action.tapTermsItem }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 사용자의 로그아웃 버튼 탭
        rootView.logoutItem.rightButton.rx.tap
            .map { MyPageReactor.Action.tapLogoutItem }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 사용자의 탈퇴하기 탭
        rootView.withdrawItem.rightButton.rx.tap
            .map { MyPageReactor.Action.tapWithdrawItem }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        // State의 사용자 이름 UI 반영
        reactor.state.map { $0.name }
            .bind(to: rootView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        // State의 사용자 프로필 이미지 UI 반영
        reactor.state.map { $0.imageURL }
            .bind { [weak self] imageURL in
                self?.rootView.profileImageView.kf.setImage(
                    with: URL(string: imageURL),
                    placeholder: UIImage(resource: .imgProfileFilled)
                )
            }
            .disposed(by: disposeBag)
    }
}
