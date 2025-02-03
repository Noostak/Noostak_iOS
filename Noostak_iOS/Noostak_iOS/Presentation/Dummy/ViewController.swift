//
//  ViewController.swift
//  Noostak_iOS
//
//  Created by 이명진 on 12/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

let mockDateList: [String] = [
    "2024-09-05T10:00:00",
    "2024-09-06T10:00:00",
    "2024-09-09T10:00:00",
    "2024-09-10T10:00:00",
    "2024-09-11T10:00:00",
    "2024-09-12T10:00:00"
]
let mockDateList2: [String] = [
    "2024-09-05T10:00:00",
    "2024-09-06T10:00:00",
    "2024-09-09T10:00:00"
]
let mockStartTime: String = "2024-09-05T08:00:00"
let mockEndTime: String = "2024-09-05T10:00:00"
let mockEndTime2: String = "2024-09-05T17:00:00"
let participants: Int = 5
let mockMemberStartTime: [String] = [
    "2024-09-05T08:00:00", // 1명
    "2024-09-05T09:00:00",
    "2024-09-05T10:00:00",
    "2024-09-05T11:00:00",
    "2024-09-05T11:00:00",
    "2024-09-05T12:00:00",
    "2024-09-05T12:00:00",
    "2024-09-06T11:00:00",
    "2024-09-06T11:00:00",
    "2024-09-06T11:00:00",
    "2024-09-06T11:00:00",
    "2024-09-06T12:00:00", // 5명
    "2024-09-06T12:00:00",
    "2024-09-06T12:00:00",
    "2024-09-06T12:00:00",
    "2024-09-06T12:00:00",
    "2024-09-06T13:00:00", // 3명
    "2024-09-06T13:00:00",
    "2024-09-06T13:00:00",
    "2024-09-06T14:00:00", // 2명
    "2024-09-06T14:00:00",
    "2024-09-06T14:00:00",
    "2024-09-06T15:00:00", // 1명
    "2024-09-06T16:00:00", // 4명
    "2024-09-06T16:00:00",
    "2024-09-06T16:00:00",
    "2024-09-06T16:00:00",
    "2024-09-05T15:00:00", // 1명
    "2024-09-05T16:00:00", // 4명
    "2024-09-05T16:00:00",
    "2024-09-05T16:00:00",
    "2024-09-05T16:00:00", // 0명
    "2024-09-05T18:00:00", // 3명
    "2024-09-05T18:00:00",
    "2024-09-05T18:00:00",
    "2024-09-05T19:00:00", // 5명
    "2024-09-05T19:00:00",
    "2024-09-05T19:00:00",
    "2024-09-05T20:00:00", // 2명
    "2024-09-05T20:00:00",
    "2024-09-05T21:00:00"  // 1명
]
let dateHeaders: [String] = NSTDateUtility.dateList(mockDateList)
let timeHeaders: [String] = NSTDateUtility.timeList(mockStartTime, mockEndTime)
let dateHeaders2: [String] = NSTDateUtility.dateList(mockDateList2)
let timeHeaders2: [String] = NSTDateUtility.timeList(mockStartTime, mockEndTime2)
let totalRows = timeHeaders.count + 1
let totalColumns = dateHeaders.count + 1
let totalRows2 = timeHeaders2.count + 1
let totalColumns2 = dateHeaders2.count + 1

final class ViewController: UIViewController {
    private lazy var schedulePicker1 = SchedulePicker(timeHeaders: timeHeaders, dateHeaders: dateHeaders, mode: .editMode)
    private lazy var schedulePicker2 = SchedulePicker(timeHeaders: timeHeaders2, dateHeaders: dateHeaders2, mode: .readMode)
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindCollectionView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(schedulePicker1)
        view.addSubview(schedulePicker2)
        
        schedulePicker1.translatesAutoresizingMaskIntoConstraints = false
        schedulePicker2.translatesAutoresizingMaskIntoConstraints = false

        schedulePicker1.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
            $0.height.equalTo(55 + totalRows * 32)
        }
        schedulePicker2.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(schedulePicker1.snp.bottom).offset(10)
            $0.height.equalTo(UIScreen.main.bounds.height - 170)
        }
    }
    
    private func bindCollectionView() {
        let items = Observable.just([
            SectionModel(model: "Section 1", items: Array(repeating: "", count: totalRows * totalColumns))
        ])
        let items2 = Observable.just([
            SectionModel(model: "Section 1", items: Array(repeating: "", count: totalRows2 * totalColumns2))
        ])
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { [weak self] _, collectionView, indexPath, _ in
                guard let self = self,
                      let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: SchedulePickerCell.identifier, for: indexPath
                      ) as? SchedulePickerCell else {
                    return UICollectionViewCell()
                }
                cell.configureHeader(for: indexPath, dateHeaders: dateHeaders, timeHeaders: timeHeaders)
                cell.configureTableRoundness(for: indexPath, dateHeaders: dateHeaders, timeHeaders: timeHeaders)
                self.schedulePicker1.configureCellBackground(cell, for: indexPath, participants: participants)
                return cell
            }
        )
        
        let dataSource2 = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { [weak self] _, collectionView, indexPath, _ in
                guard let self = self,
                      let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: SchedulePickerCell.identifier, for: indexPath
                      ) as? SchedulePickerCell else {
                    return UICollectionViewCell()
                }
                cell.configureHeader(for: indexPath, dateHeaders: dateHeaders2, timeHeaders: timeHeaders2)
                cell.configureTableRoundness(for: indexPath, dateHeaders: dateHeaders2, timeHeaders: timeHeaders2)
                self.schedulePicker2.configureCellBackground(cell, for: indexPath, participants: participants)
                self.schedulePicker2.updateCellAvailability(with: mockDateList, startTimes: mockMemberStartTime)
                return cell
            }
        )
        items
            .bind(to: schedulePicker1.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        items2
            .bind(to: schedulePicker2.rx.items(dataSource: dataSource2))
            .disposed(by: disposeBag)
        
        schedulePicker1.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let row = indexPath.item / totalColumns
                let column = indexPath.item % totalColumns
                
                guard row > 0, column > 0 else {
                    self.schedulePicker1.deselectItem(at: indexPath, animated: true) // 첫 번째 행과 첫 번째 열은 선택 불가
                    return
                }
                self.schedulePicker1.addSelectedCell(at: indexPath)
            })
            .disposed(by: disposeBag)
    }
}
