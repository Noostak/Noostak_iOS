//
//  SchedulePicker.swift
//  Noostak_iOS
//
//  Created by 오연서 on 1/10/25.
//

import UIKit

final class SchedulePicker: UICollectionView {
    enum Mode {
        case editMode
        case readMode
    }
    
    private let layout = SchedulePickerLayout()
    private let timeHeaders: [String]
    private let dateHeaders: [String]
    private let mode: Mode
    private var selectedCells: Set<IndexPath> = [] // edit Mode
    private var cellAvailability: [IndexPath: Int] = [:] // read Mode

    init(timeHeaders: [String], dateHeaders: [String], mode: Mode) {
        self.timeHeaders = timeHeaders
        self.dateHeaders = dateHeaders
        self.mode = mode
        super.init(frame: .zero, collectionViewLayout: layout)
        self.layout.configure(totalRows: timeHeaders.count + 1, totalColumns: dateHeaders.count + 1)
        self.register(SchedulePickerCell.self, forCellWithReuseIdentifier: SchedulePickerCell.identifier)
        self.cellAvailability = calculateCellAvailability(totalRows: timeHeaders.count + 1,
                                                          totalColumns: dateHeaders.count + 1,
                                                          //Fix: mockMemberStartTime 변경 필요
                                                          startTimes: mockMemberStartTime)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSelectedCell(at indexPath: IndexPath) {
        guard mode == .editMode else { return }
        if let cell = cellForItem(at: indexPath) as? SchedulePickerCell {
            cell.isSelectedCell.toggle()
            if cell.isSelectedCell {
                selectedCells.insert(indexPath)
            } else {
                selectedCells.remove(indexPath)
            }
        }
    }
    
    func configureCellBackground(_ cell: SchedulePickerCell, for indexPath: IndexPath, participants: Int) {
        guard mode == .readMode else { return }
        let count = cellAvailability[indexPath, default: 0]
        let ratio = Float(count) / Float(participants)
        
        switch ratio {
        case 0.01...0.2:
            cell.backgroundColor = .appBlue50
        case 0.2...0.4:
            cell.backgroundColor = .appBlue200
        case 0.4...0.6:
            cell.backgroundColor = .appBlue400
        case 0.6...0.8:
            cell.backgroundColor = .appBlue700
        case 0.8...1:
            cell.backgroundColor = .appBlue800
        default:
            cell.backgroundColor = .clear
        }
    }
}

/// .ReadMode 색상 반환 로직
extension SchedulePicker {
    ///각 시간에 대한 가능 인원 계산
    private func calculateCellAvailability(totalRows: Int, totalColumns: Int, startTimes: [String]) -> [IndexPath: Int] {
        var cellAvailability: [IndexPath: Int] = [:]
        let dateTimeMapping = createDateTimeMapping(totalRows: totalRows, totalColumns: totalColumns)
        for startTime in startTimes {
            if let indexPath = dateTimeMapping[startTime] {
                cellAvailability[indexPath, default: 0] += 1
            }
        }
        return cellAvailability
    }
    
    /// 시각 - cell 매핑
    private func createDateTimeMapping(totalRows: Int, totalColumns: Int) -> [String: IndexPath] {
        var mapping: [String: IndexPath] = [:]
        //FIX: mockDateList 변경 필요
        let dates = mockDateList.map { String($0.prefix(10)) }
        
        for row in 1..<totalRows {
            for column in 1..<totalColumns {
                let time = self.timeHeaders[row - 1] // 시간
                guard column - 1 < dates.count else { continue }
                let date = dates[column - 1] // 날짜
                let combinedKey = "\(date)T\(time):00:00"
                let indexPath = IndexPath(item: (row * totalColumns) + column, section: 0)
                mapping[combinedKey] = indexPath
            }
        }
        return mapping
    }

    func reloadCellBackgrounds() {
        self.cellAvailability = calculateCellAvailability(totalRows: self.timeHeaders.count + 1,
                                                          totalColumns: self.dateHeaders.count + 1,
                                                          startTimes: mockMemberStartTime)
        self.reloadData()
    }
}
