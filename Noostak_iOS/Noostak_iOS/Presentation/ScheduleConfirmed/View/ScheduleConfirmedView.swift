//
//  ScheduleConfirmedView.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/10/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class ScheduleConfirmedView: UIView {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    // MARK: Views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let scheduleInfoLabel = UILabel()
    let scheduleInfoView = ScheduleInfoView(state: .confirmed)
    
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
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [scheduleInfoLabel, scheduleInfoView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setUpFoundation() {
        self.backgroundColor = .appWhite
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        scheduleInfoLabel.do {
            $0.text = "약속 정보"
            $0.font = .PretendardStyle.t4_b.font
            $0.textColor = .appBlack
        }
        
        scheduleInfoView.do {
            $0.layer.cornerRadius = 20
            $0.layer.borderColor = UIColor.appGray100.cgColor
            $0.layer.borderWidth = 1
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
            $0.bottom.equalTo(scheduleInfoView.snp.bottom)
        }
        
        scheduleInfoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        scheduleInfoView.snp.makeConstraints {
            $0.top.equalTo(scheduleInfoLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

let mockExtendedSchedule = ExtendedSchedule(schedule: Schedule(id: 1,
                                                               name: "누탁",
                                                               category: .hobby,
                                                               selectionDates: [],
                                                               selectionStartTime: Date(),
                                                               selectionEndTime: Date()),
                                            date: "2024-09-07T00:00:00",
                                            startTime: "2024-09-07T11:00:00",
                                            endTime: "2024-09-07T14:00:00",
                                            myInfo: .unavailable,
                                            availableMembers: [User(name: "안녕", userImage: ""),
                                                               User(name: "안녕안", userImage: ""),
                                                               User(name: "안녕안녕", userImage: "")],
                                            unavailableMembers: [User(name: "알료", userImage: ""),
                                                                 User(name: "언넝", userImage: ""),
                                                                 User(name: "언넝언넝언넝", userImage: ""),
                                                                 User(name: "언넝", userImage: ""),
                                                                 User(name: "언넝언넝", userImage: "")
                                                                ],
                                            groupMemberCount: 10,
                                            availableMemberCount: 3)
