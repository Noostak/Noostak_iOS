//
//  ScheduleConfirmedViewController.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/11/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

final class ScheduleConfirmedViewController: UIViewController, View, UIScrollViewDelegate {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let rootView = ScheduleConfirmedView()
    
    // MARK: - Init
    init(reactor: ScheduleConfirmedReactor) {
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
        bindCollectionViewHeight()
    }
    
    private func setUpFoundation() {
        self.view.backgroundColor = .white
    }
    
    private func setUpCollectionView() {
        let availableFlowLayout = LeftAlignedFlowLayout()
        availableFlowLayout.minimumInteritemSpacing = 10
        availableFlowLayout.minimumLineSpacing = 10
        
        let unavailableFlowLayout = LeftAlignedFlowLayout()
        unavailableFlowLayout.minimumInteritemSpacing = 10
        unavailableFlowLayout.minimumLineSpacing = 10

        rootView.scheduleInfoView.availableCollectionView.setCollectionViewLayout(availableFlowLayout, animated: false)
        rootView.scheduleInfoView.unavailableCollectionView.setCollectionViewLayout(unavailableFlowLayout, animated: false)
        
        rootView.scheduleInfoView.availableCollectionView.register(MemberAvailabilityCVC.self, forCellWithReuseIdentifier: MemberAvailabilityCVC.identifier)
        rootView.scheduleInfoView.unavailableCollectionView.register(MemberAvailabilityCVC.self, forCellWithReuseIdentifier: MemberAvailabilityCVC.identifier)
        rootView.scheduleInfoView.availableCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        rootView.scheduleInfoView.unavailableCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func bindCollectionViewHeight() {
        rootView.scheduleInfoView.availableCollectionView.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
        rootView.scheduleInfoView.unavailableCollectionView.snp.makeConstraints { make in
            make.height.equalTo(0)
        }

        rootView.scheduleInfoView.availableCollectionView.rx.observe(CGSize.self, "contentSize")
            .subscribe(onNext: { [weak self] size in
                guard let height = size?.height, height > 0, let self = self else { return }
                self.rootView.scheduleInfoView.availableCollectionView.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
                self.rootView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)

        rootView.scheduleInfoView.unavailableCollectionView.rx.observe(CGSize.self, "contentSize")
            .subscribe(onNext: { [weak self] size in
                guard let height = size?.height, height > 0, let self = self else { return }
                self.rootView.scheduleInfoView.unavailableCollectionView.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
                self.rootView.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: ScheduleConfirmedReactor) {
        let myStatus = reactor.currentState.schedule.myInfo
        var availableMembers = reactor.currentState.availableMembers
        var unavailableMembers = reactor.currentState.unavailableMembers
        
        myStatus == .available ? availableMembers.insert(User(name: "나", userImage: ""), at: 0) :
                                unavailableMembers.insert(User(name: "나", userImage: ""), at: 0)
        
        let availableDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, User>>(
            configureCell: { _, collectionView, indexPath, user in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberAvailabilityCVC.identifier, for: indexPath) as! MemberAvailabilityCVC
                let status: MemberStatus = (indexPath.row == 0 && myStatus == .available) ? .myself : .available
                cell.reactor = MemberAvailabilityCellReactor(user: user, status: status)
                return cell
            }
        )

        let unavailableDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, User>>(
            configureCell: { _, collectionView, indexPath, user in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberAvailabilityCVC.identifier, for: indexPath) as! MemberAvailabilityCVC
                let status: MemberStatus = (indexPath.row == 0 && myStatus == .unavailable) ? .myself : .unavailable
                cell.reactor = MemberAvailabilityCellReactor(user: user, status: status)
                return cell
            }
        )
        
        reactor.state.map { _ in [SectionModel(model: "Available", items: availableMembers)] }
            .bind(to: rootView.scheduleInfoView.availableCollectionView.rx.items(dataSource: availableDataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { _ in [SectionModel(model: "Unavailable", items: unavailableMembers)] }
            .bind(to: rootView.scheduleInfoView.unavailableCollectionView.rx.items(dataSource: unavailableDataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.schedule }
            .subscribe(onNext: { [weak self] schedule in
                guard let self = self else { return }
                self.rootView.scheduleInfoView.scheduleTimeLabel.text = "\(scheduleStartTime(schedule.startTime))"
                self.rootView.scheduleInfoView.scheduleCategoryChip = ScheduleCategoryButton(category: schedule.schedule.category, buttonType: .ReadOnly)
                self.rootView.scheduleInfoView.availableLabel.text = "가능한 친구 \(schedule.availableMembers.count)"
                self.rootView.scheduleInfoView.unavailableLabel.text = "가능한 친구 \(schedule.unavailableMembers.count)"

            })
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension ScheduleConfirmedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let reactor = self.reactor else { return CGSize(width: 39, height: 30) }

        let isAvailableCollection = (collectionView == rootView.scheduleInfoView.availableCollectionView)
        let myStatus = reactor.currentState.schedule.myInfo
        let isFirstCellMyself = (indexPath.row == 0) && ((isAvailableCollection && myStatus == .available) || (!isAvailableCollection && myStatus == .unavailable))
        let members = isAvailableCollection ? reactor.currentState.availableMembers : reactor.currentState.unavailableMembers
        let user: User
        
        if isFirstCellMyself {
            user = User(name: "나", userImage: "")
            return CGSize(width: 39, height: 30)
        } else {
            let adjustedIndex = (isAvailableCollection && myStatus == .available) || (!isAvailableCollection && myStatus == .unavailable) ? indexPath.row - 1 : indexPath.row
            user = members[adjustedIndex]
        }
        let attributes = [NSAttributedString.Key.font: UIFont.PretendardStyle.c3_r.font]
        let estimatedFrame = (user.name as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        return CGSize(width: max(39, estimatedFrame.width + 18), height: 30)
    }
}

// MARK: - TimeFormatter
extension ScheduleConfirmedViewController {
    func scheduleStartTime (_ startTime: String) -> String {
        let formatter = NSTDateUtility(format: .yyyyMMddTHHmmss)
        let timeFormatter = NSTDateUtility(format: .MMddHHmm)
        
        let startDateResult = formatter.date(from: startTime)
        
        guard case .success(let startDate) = startDateResult else {
            return "Invalid date format"
        }
        return "\(timeFormatter.string(from: startDate))"
    }
}
