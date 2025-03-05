//
//  AvailabilityCreateView.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/26/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

let mockDateList: [String] = [
    "2024-09-05T10:00:00",
    "2024-09-06T10:00:00",
    "2024-09-09T10:00:00",
    "2024-09-10T10:00:00",
    "2024-09-11T10:00:00",
    "2024-09-12T10:00:00"
]
let mockStartTime: String = "2024-09-05T08:00:00"
let mockEndTime: String = "2024-09-05T23:00:00"
let totalRows = timeHeaders.count + 1
let totalColumns = dateHeaders.count + 1
let dateHeaders: [String] = NSTDateUtility.dateList(mockDateList)
let timeHeaders: [String] = NSTDateUtility.timeList(mockStartTime, mockEndTime)

final class AvailabilityCreateView: UIView {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    // MARK: Views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let availbilityLabel = UILabel()
    let schedulePickerView = SchedulePicker(timeHeaders: timeHeaders, dateHeaders: dateHeaders, mode: .readMode)
    let confirmButton = AppThemeButton(theme: .grayScale, title: "확인")
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFoundation()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [scrollView, confirmButton].forEach {
            self.addSubview($0)
        }
        scrollView.addSubview(contentView)
        [availbilityLabel, schedulePickerView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setUpFoundation() {
        self.backgroundColor = .appWhite
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        availbilityLabel.do {
            $0.text = "가능한 시간을\n모두 선택해주세요"
            $0.numberOfLines = 2
            $0.font = .PretendardStyle.h4_b.font
        }
        
        schedulePickerView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        confirmButton.do {
            $0.backgroundColor = .appGray900
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(schedulePickerView.snp.bottom)
        }
        
        availbilityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(54)
        }
        
        schedulePickerView.snp.makeConstraints {
            $0.top.equalTo(availbilityLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(62)
        }
    }
}

extension NSTDateUtility {
    ///타임테이블 뷰 : "요일 월/일"
    static func dateList(_ dateStrings: [String]) -> [String] {
        let formatter = NSTDateUtility(format: .yyyyMMddTHHmmss) // ISO 8601 형식
        let displayFormatter = NSTDateUtility(format: .EEMMdd) // 출력 형식
        
        return dateStrings.compactMap { dateString in
            switch formatter.date(from: dateString) {
            case .success(let date):
                return displayFormatter.string(from: date)
            case .failure(let error):
                print("Failed to parse date \(dateString): \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    ///타임테이블 뷰 : "00시"
    static func timeList(_ startTime: String, _ endTime: String) -> [String] {
        let formatter = NSTDateUtility(format: .yyyyMMddTHHmmss) // ISO 8601 형식
        var result: [String] = []
        
        switch (formatter.date(from: startTime), formatter.date(from: endTime)) {
        case (.success(let start), .success(let end)):
            let calendar = Calendar.current
            var current = start
            
            while current <= end {
                result.append(NSTDateUtility(format: .HH).string(from: current)) // 출력 형식
                if let nextHour = calendar.date(byAdding: .hour, value: 1, to: current) {
                    current = nextHour
                } else {
                    break
                }
            }
        default:
            print("Failed to parse start or end time.")
            return []
        }
        return result
    }
    
    static func selectedCellsToDateTime(selectedCells: Set<IndexPath>, dateHeaders: [String], timeHeaders: [String], originalDateList: [String]) -> [String] {
        let formatter = NSTDateUtility(format: .EEMMdd) // dateList 출력형식
        let originalFormatter = NSTDateUtility(format: .yyyyMMddTHHmmss) // ISO 8601 원본 포맷
        
        return selectedCells.compactMap { indexPath in
            let column = indexPath.item % dateHeaders.count
            let row = indexPath.item / dateHeaders.count
            let selectedDateHeader = dateHeaders[column]
            let selectedTimeHeader = timeHeaders[row]

            guard let originalDate = originalDateList.first(where: {
                switch originalFormatter.date(from: $0) {
                case .success(let parsedDate):
                    return formatter.string(from: parsedDate) == selectedDateHeader
                case .failure:
                    return false
                }
            }) else { return nil }

            return "\(originalDate.prefix(10))T\(selectedTimeHeader):00:00"
        }
    }
}
