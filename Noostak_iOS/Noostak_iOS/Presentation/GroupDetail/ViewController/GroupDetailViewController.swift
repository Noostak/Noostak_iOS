//
//  GroupDetailViewController.swift
//  Noostak_iOS
//
//  Created by 오연서 on 1/31/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

final class GroupDetailViewController: UIViewController, View {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let rootView = GroupDetailView()
    
    // MARK: - Init
    init(reactor: GroupDetailReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFoundation()
        setUpCollectionView()
    }
    
    private func setUpFoundation() {
        self.view.backgroundColor = .white
    }
    
    private func setUpCollectionView() {
        rootView.inProgressCollectionView.register(InProgressCVC.self, forCellWithReuseIdentifier: InProgressCVC.identifier)
        rootView.confirmedCollectionView.register(ConfirmedCVC.self, forCellWithReuseIdentifier: ConfirmedCVC.identifier)
        rootView.inProgressCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        rootView.confirmedCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        DispatchQueue.main.async {
            self.rootView.layoutIfNeeded()
        }
    }
    
    // MARK: - Bind Reactor
    func bind(reactor: GroupDetailReactor) {
        rootView.segmentedControl.rx.selectedSegmentIndex
            .distinctUntilChanged()
            .flatMapLatest { index -> Observable<Reactor.Action> in
                if index == 0 {
                    return Observable.concat([
                        .just(.selectSegment(index)),
                        .just(.loadInProgressData)
                    ])
                } else {
                    return Observable.concat([
                        .just(.selectSegment(index)),
                        .just(.loadConfirmedData)
                    ])
                }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                
                let isProgress = (state.selectedSegmentIndex == 0)
                self.rootView.inProgressCollectionView.isHidden = !isProgress
                self.rootView.confirmedCollectionView.isHidden = isProgress
                
                let noData = isProgress ? state.inProgressCellReactors.isEmpty : state.confirmedCellReactors.isEmpty
                self.rootView.defaultLabel.text = isProgress ? "현재 진행중인 약속이 없어요" : "아직 확정된 약속이 없어요"
                self.rootView.defaultLabel.isHidden = !noData
            })
            .disposed(by: disposeBag)
        
        // 진행 중 바인딩
        reactor.state.map { $0.inProgressCellReactors }
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in
                self.rootView.inProgressCollectionView.reloadData()
            })
            .bind(to: rootView.inProgressCollectionView.rx.items(cellIdentifier: InProgressCVC.identifier, cellType: InProgressCVC.self)) { index, reactor, cell in
                cell.reactor = reactor
            }
            .disposed(by: disposeBag)
        
        // 확정된 약속 바인딩
        reactor.state.map { $0.confirmedCellReactors }
            .do(onNext: { _ in self.rootView.confirmedCollectionView.reloadData() })
            .bind(to: rootView.confirmedCollectionView.rx.items(cellIdentifier: ConfirmedCVC.identifier, cellType: ConfirmedCVC.self)) { index, reactor, cell in
                cell.reactor = reactor
            }
            .disposed(by: disposeBag)
    }
}

extension GroupDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case rootView.inProgressCollectionView:
            return CGSize(width: UIScreen.main.bounds.width - 28, height: 105)
        case rootView.confirmedCollectionView:
            return CGSize(width: UIScreen.main.bounds.width - 32, height: 72)
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case rootView.inProgressCollectionView:
            return 11
        case rootView.confirmedCollectionView:
            return 2
        default:
            return 0
        }
    }
}
