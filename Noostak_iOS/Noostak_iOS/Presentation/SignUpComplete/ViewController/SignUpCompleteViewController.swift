//
//  SignUpCompleteViewController.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/25/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class SignUpCompleteViewController: UIViewController, View {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    // MARK: Views
    private let rootView: SignUpCompleteView
    
    init(reactor: SignUpCompleteReactor) {
        rootView = SignUpCompleteView(name: reactor.currentState.name)
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
    func bind(reactor: SignUpCompleteReactor) {
        // MARK: Action
        // 사용자의 "초대 받은 그룹이 없어요" 버튼 탭
        rootView.noGroupButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { SignUpCompleteReactor.Action.tapNoGroupButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 사용자의 "그룹코드 입력하기" 버튼 탭
        rootView.enterGroupCodeButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { SignUpCompleteReactor.Action.tapEnterGroupCodeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
