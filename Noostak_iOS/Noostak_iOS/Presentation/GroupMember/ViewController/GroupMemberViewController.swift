//
//  GroupMemberViewController.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/9/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

final class GroupMemberViewController: UIViewController, View {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let rootView = GroupMemberView()
    
    // MARK: - Init
    init(reactor: GroupMemberReactor) {
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
        rootView.groupMemberCollectionView.register(GroupMemberCVC.self, forCellWithReuseIdentifier: GroupMemberCVC.identifier)
        rootView.groupMemberCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    // MARK: - Bind Reactor
    func bind(reactor: GroupMemberReactor) {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, User>>(
            configureCell: { _, collectionView, indexPath, user in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupMemberCVC.identifier, for: indexPath) as? GroupMemberCVC else {
                    return UICollectionViewCell()
                }
                let cellReactor = GroupMemberCellReactor(user: user)
                cell.reactor = cellReactor
                return cell
            }
        )

        reactor.state.map { [SectionModel(model: "Members", items: $0.group.members)] }
            .do(onNext: { [weak self] sections in
                let isEmpty = sections.first?.items.isEmpty ?? true
                self?.rootView.defaultLabel.isHidden = !isEmpty
            })
            .bind(to: rootView.groupMemberCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.group }
            .subscribe(onNext: { [weak self] group in
                guard let self = self else { return }
                self.rootView.groupProfileImageView.image = .imgProfileFilled // api 연결시 변경
                self.rootView.groupNameLabel.text = group.name
                self.rootView.groupMemberTotalLabel.text = "그룹 멤버 \(group.membersCount)"
                self.rootView.groupMemberLabel.text = "멤버 (\(group.membersCount)/50)"
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.group.host }
            .subscribe(onNext: { [weak self] host in
                guard let self = self else { return }
                self.rootView.groupHostName.text = host.name
                self.rootView.groupHostProfile.image = .imgProfileFilled // api 연결시 변경
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension GroupMemberViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 61, height: 83)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
