//
//  AvailabilityCreateViewController.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/26/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

final class AvailabilityCreateViewController: UIViewController, View {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let rootView = AvailabilityCreateView()
    
    // MARK: - Init
    init(reactor: AvailabilityCreateReactor) {
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
        bindCollectionView()
    }
    
    private func setUpFoundation() {
        self.view.backgroundColor = .white
    }
    
    private func bindCollectionView() {
        let items = Observable.just([
            SectionModel(model: "Section 1", items: Array(repeating: "", count: totalRows * totalColumns))
        ])
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { _, collectionView, indexPath, _ in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SchedulePickerCell.identifier, for: indexPath
                ) as? SchedulePickerCell else {
                    return UICollectionViewCell()
                }
                cell.configureHeader(for: indexPath, dateHeaders: dateHeaders, timeHeaders: timeHeaders)
                cell.configureTableRoundness(for: indexPath, dateHeaders: dateHeaders, timeHeaders: timeHeaders)
                return cell
            }
        )
        items
            .bind(to: rootView.schedulePickerView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: AvailabilityCreateReactor) {
        rootView.confirmButton.bind(state: Observable.just(.able))
        
        rootView.schedulePickerView.rx.itemSelected
            .compactMap { [weak self] indexPath -> AvailabilityCreateReactor.Action? in
                guard let self = self else { return nil }
                let row = indexPath.item / totalColumns
                let column = indexPath.item % totalColumns
                // 헤더 행과 열 선택 비활성화
                guard row > 0, column > 0 else {
                    self.rootView.schedulePickerView.deselectItem(at: indexPath, animated: true)
                    return nil
                }
                return AvailabilityCreateReactor.Action.selectCell(indexPath)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        rootView.confirmButton.rx.tap
            .map { AvailabilityCreateReactor.Action.tapConfirmAvailableTimes }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.selectedCells }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] selectedCells in
                guard let self = self else { return }
                self.rootView.schedulePickerView.visibleCells.forEach { cell in
                    guard let indexPath = self.rootView.schedulePickerView.indexPath(for: cell) else { return }
                    let isSelected = selectedCells.contains(indexPath)
                    cell.backgroundColor = isSelected ? .appBlue400 : .clear
                }
            })
            .disposed(by: disposeBag)
    }
}
