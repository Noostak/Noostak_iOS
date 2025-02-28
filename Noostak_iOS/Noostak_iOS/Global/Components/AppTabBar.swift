//
//  AppTabBar.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/26/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

/// 탭 정보를 담는 모델
struct AppTabBarItem {
    let title: String
    let selectedImage: UIImage?
    let unselectedImage: UIImage?
}

/// 앱 전반적으로 사용되는 앱 테마 탭 바입니다
final class AppTabBar: UIView {
    
    /// 탭 정보를 표시하는 뷰 구조체
    private struct TabBarItemContainer {
        let stackView: UIStackView
        let imageView: UIImageView
        let label: UILabel
    }
    
    // MARK: Properties
    static let tabBarHeight: CGFloat = 52
    static let buttonSize: CGFloat = 40
    private var tabItems: [AppTabBarItem] = []
    private let disposeBag = DisposeBag()
    private let _selectedIndexRelay = BehaviorRelay<Int>(value: 0)
    
    // MARK: Views
    private let dividerView = UIView()
    private var itemViews: [TabBarItemContainer] = []
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.snp.updateConstraints {
            $0.height.equalTo(AppTabBar.tabBarHeight + UIScreen.safeAreaBottom)
        }
        
        stackView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(UIScreen.safeAreaBottom)
        }
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        self.addSubviews(stackView, dividerView)
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        self.backgroundColor = .white

        dividerView.do {
            $0.backgroundColor = UIColor.appGray200
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fillEqually
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(AppTabBar.tabBarHeight)
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(AppTabBar.tabBarHeight)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

// MARK: Interface
extension AppTabBar {
    var selectedIndexRelay: BehaviorRelay<Int> {
        return self._selectedIndexRelay
    }
    
    /// 탭 아이템 설정
    func setTabItems(_ items: [AppTabBarItem]) {
        resetTabBar()
        tabItems = items
        for (index, item) in items.enumerated() {
            let tabView = createTabItemView(for: item, index: index)
            stackView.addArrangedSubview(tabView.stackView)
            itemViews.append(tabView)
            bindTapGesture(to: tabView.stackView, index: index)
        }
    }
    
    /// 탭 아이템 선택
    func selectTab(index: Int) {
        guard index >= 0, index < itemViews.count else { return }
        selectedIndexRelay.accept(index)
        
        for (i, viewTuple) in itemViews.enumerated() {
            let isSelected = i == index
            let item = tabItems[i]
            
            viewTuple.imageView.image = isSelected ? item.selectedImage : item.unselectedImage
            viewTuple.label.textColor = isSelected ? .appGray900 : .appGray500
        }
    }
}

// MARK: Internal Logic
private extension AppTabBar {
    /// 탭바 초기화
    func resetTabBar() {
        tabItems.removeAll()
        itemViews.forEach { $0.stackView.removeFromSuperview() }
        itemViews.removeAll()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    /// 탭 아이템 데이터에서 뷰 생성
    private func createTabItemView(for item: AppTabBarItem, index: Int) -> TabBarItemContainer {
        let imageView = UIImageView().then {
            $0.image = item.unselectedImage
            $0.contentMode = .scaleAspectFit
            $0.snp.makeConstraints {
                $0.size.equalTo(24)
            }
        }
        
        let label = UILabel().then {
            $0.text = item.title
            $0.font = .PretendardStyle.c4_r.font
            $0.textColor = .appGray500
            $0.textAlignment = .center
        }
        
        let stackButton = UIStackView(arrangedSubviews: [imageView, label]).then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 4
            $0.isUserInteractionEnabled = true
        }
       
        return .init(stackView: stackButton, imageView: imageView, label: label)
    }
    
    /// 탭 버튼에 탭 이벤트를 바인딩
    private func bindTapGesture(to stackButton: UIStackView, index: Int) {
        let tapGesture = UITapGestureRecognizer()
        stackButton.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .map { _ in index }
            .bind { [weak self] index in
                self?.selectTab(index: index)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Rx Extension
extension Reactive where Base: AppTabBar {
    var selectedIndex: ControlProperty<Int> {
        let selectedIndexRelay = base.selectedIndexRelay

        return ControlProperty(
            values: selectedIndexRelay.asObservable(),
            valueSink: Binder(base) { tabBar, index in
                tabBar.selectedIndexRelay.accept(index)
            }
        )
    }
}
