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
        setupLayout()
        setupFoundation()
    }
    
    private func setupLayout() {
        layout.configure(totalRows: timeHeaders.count + 1, totalColumns: dateHeaders.count + 1)
    }

    private func setupFoundation() {
        self.register(SchedulePickerCell.self, forCellWithReuseIdentifier: SchedulePickerCell.identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func addSelectedCell(at indexPath: IndexPath) {
        guard mode == .editMode,
              let cell = cellForItem(at: indexPath) as? SchedulePickerCell
        else { return }
        cell.isSelectedCell.toggle()
        if cell.isSelectedCell {
            selectedCells.insert(indexPath)
        } else {
            selectedCells.remove(indexPath)
        }
    }
    
    func configureCellBackground(_ cell: SchedulePickerCell, for indexPath: IndexPath, participants: Int) {
        guard mode == .readMode else { return }
        let count = cellAvailability[indexPath, default: 0]
        let ratio = Float(count) / Float(participants)
        cell.backgroundColor = calculateBackgroundColor(for: ratio)
    }

    func updateCellAvailability(with dateList: [String], startTimes: [String]) {
        guard mode == .readMode else { return }
        self.cellAvailability = calculateCellAvailability(totalRows: self.timeHeaders.count + 1,
                                                          totalColumns: self.dateHeaders.count + 1,
                                                          dateList: dateList,
                                                          startTimes: startTimes)
        reloadData()
    }
}

// MARK: Internal Logics
extension SchedulePicker {
    ///각 시간에 대한 가능 인원 계산
    private func calculateCellAvailability(totalRows: Int, totalColumns: Int, dateList: [String], startTimes: [String]) -> [IndexPath: Int] {
        var cellAvailability: [IndexPath: Int] = [:]
        let dateTimeMapping = createDateTimeMapping(totalRows: totalRows, totalColumns: totalColumns, dateList: dateList)
        for startTime in startTimes {
            if let indexPath = dateTimeMapping[startTime] {
                cellAvailability[indexPath, default: 0] += 1
            }
        }
        return cellAvailability
    }
    
    /// 시각 - cell 매핑
    private func createDateTimeMapping(totalRows: Int, totalColumns: Int, dateList: [String]) -> [String: IndexPath] {
        var mapping: [String: IndexPath] = [:]
        let dates = dateList.map { String($0.prefix(10)) }
        
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
    
    private func calculateBackgroundColor(for ratio: Float) -> UIColor {
        switch ratio {
        case 0.01...0.2: return .appBlue50
        case 0.2...0.4: return .appBlue200
        case 0.4...0.6: return .appBlue400
        case 0.6...0.8: return .appBlue700
        case 0.8...1: return .appBlue800
        default: return .clear
        }
    }
}
