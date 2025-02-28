//
//  AppTabBarController.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/27/25.
//

import UIKit
import RxSwift
import SnapKit

final class AppTabBarController: UITabBarController {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    // MARK: Views
    private let appTabBar = AppTabBar()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFoundation()
        setUpHierarchy()
        setUpLayout()
        bind()
        appTabBar.selectTab(index: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let tabBarHeight = AppTabBar.tabBarHeight + UIScreen.safeAreaBottom
        
        appTabBar.snp.updateConstraints {
            $0.height.equalTo(tabBarHeight)
        }
        
        additionalSafeAreaInsets.bottom = tabBarHeight
    }
    
    // MARK: setUpFoundation
    private func setUpFoundation() {
        tabBar.isHidden = true
        
        let items: [AppTabBarItem] = [
            AppTabBarItem(
                title: "캘린더",
                selectedImage: UIImage(resource: .icnBtmnaviHomeOn24),
                unselectedImage: UIImage(resource: .icnBtmnaviHomeOff24)
            ),
            AppTabBarItem(
                title: "그룹",
                selectedImage: UIImage(resource: .icnBtmnaviGroupOn24),
                unselectedImage: UIImage(resource: .icnBtmnaviGroupOff24)
            ),
            AppTabBarItem(
                title: "내정보",
                selectedImage: UIImage(resource: .icnBtmnaviMypageOn24),
                unselectedImage: UIImage(resource: .icnBtmnaviMypageOff24)
            )
        ]
        appTabBar.setTabItems(items)
        
        setViewControllers([
            ViewController(),
            SignUpViewController(reactor: .init(userUseCase: UserUseCase())),
            ViewController()
        ], animated: false)
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        view.addSubview(appTabBar)
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        appTabBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: bind
    private func bind() {
        appTabBar.rx.selectedIndex
            .bind { [weak self] index in
                self?.selectedIndex = index
            }
            .disposed(by: disposeBag)
    }
}
