//
//  MakeGroupCompleteViewController.swift
//  Noostak_iOS
//
//  Created by 박민서 on 3/1/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class MakeGroupCompleteViewController: UIViewController, View {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    // MARK: Views
    private let rootView: MakeGroupCompleteView
    
    init(reactor: MakeGroupCompleteReactor) {
        rootView = MakeGroupCompleteView(groupCode: reactor.currentState.groupCode)
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
    func bind(reactor: MakeGroupCompleteReactor) {
        // MARK: Action
        // 사용자의 창 닫기 버튼 탭
        rootView.topBar.leftButton.rx.tap
            .map { MakeGroupCompleteReactor.Action.tapDismissButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 사용자의 "그룹코드 복사하기" 버튼 탭
        rootView.copyGroupCodeButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { MakeGroupCompleteReactor.Action.tapCopyGroupCodeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 사용자의 "그룹코드 보내기" 버튼 탭
        rootView.sendGroupCodeButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { MakeGroupCompleteReactor.Action.tapSendGroupCodeButton(vc: self) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
