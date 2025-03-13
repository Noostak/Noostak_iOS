//
//  MakeAppointmentTimeView.swift
//  Noostak_iOS
//
//  Created by 이명진 on 3/11/25.
//

import UIKit

import Then
import SnapKit

import RxSwift
import RxCocoa

final class MakeAppointmentTimeView: UIView {
    
    // MARK: - TimeSelectorType

    enum TimeSelectorType {
        case start
        case end
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    // 약속 시작 시간, 약속 종료 시간
    fileprivate lazy var selectedTimeRange: Observable<(String, String)> = {
        return Observable.combineLatest(self.startPicker.rx.time, self.endPicker.rx.time)
    }()
    
    // MARK: - UIComponents
    
    private let contentView = UIView().then {
        $0.backgroundColor = .appGray50Bg
    }
    
    private let waveLabel = UILabel().then {
        $0.text = "~"
        $0.font = .PretendardStyle.h1_b.font
        $0.textColor = .appGray600
    }
    
    private let startPicker = CustomTimePickerView()
    
    private let endPicker = CustomTimePickerView().then {
        $0.isHidden = true
    }
    
    private let startLabel = UILabel().then {
        $0.text = "약속 시작 시간"
        $0.font = .PretendardStyle.c3_sb.font
        $0.textColor = .appGray700
    }
    
    private let startTimeLabel = UILabel().then {
        $0.font = .PretendardStyle.h1_b.font
        $0.text = "12:00"
        $0.textColor = .appBlue600
    }
    
    private let endLabel = UILabel().then {
        $0.text = "약속 종료 시간"
        $0.font = .PretendardStyle.c3_sb.font
        $0.textColor = .appGray700
    }
    
    private let endTimeLabel = UILabel().then {
        $0.font = .PretendardStyle.h1_b.font
        $0.text = "13:00"
    }
    
    private lazy var startTimeStackView = UIStackView(
        arrangedSubviews: [
            startLabel,
            startTimeLabel
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    
    private lazy var endTimeStackView = UIStackView(
        arrangedSubviews: [
            endLabel,
            endTimeLabel
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    
    private lazy var topViewStackView = UIStackView(
        arrangedSubviews: [
            startTimeStackView,
            waveLabel,
            endTimeStackView
        ]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 20
    }
    
    private var timeSelectMode: TimeSelectorType = .start
    
    private let dummyLine = UIView().then {
        $0.backgroundColor = .appGray100
    }
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setLayout()
        bind()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MakeAppointmentTimeView {
    private func setUI() {
        backgroundColor = .white
        contentView.layer.cornerRadius = 20
    }
    
    private func setHierarchy() {
        self.addSubview(contentView)
        
        contentView.addSubviews(
            topViewStackView,
            dummyLine,
            startPicker,
            endPicker
        )
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(307)
            $0.width.equalTo(343)
        }
        
        topViewStackView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        dummyLine.snp.makeConstraints {
            $0.top.equalTo(topViewStackView.snp.bottom).offset(9)
            $0.horizontalEdges.equalToSuperview().inset(41)
            $0.height.equalTo(3)
        }
        
        startPicker.snp.makeConstraints {
            $0.top.equalTo(dummyLine.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(152)
            $0.width.equalTo(178)
        }
        
        endPicker.snp.makeConstraints {
            $0.top.equalTo(topViewStackView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(152)
            $0.width.equalTo(178)
        }
    }
    
    private func bind() {
        startPicker.rx.time
            .bind(to: startTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        endPicker.rx.time
            .bind(to: endTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        startTimeLabel.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.timeSelectMode = .start
                self.updateUI()
            })
            .disposed(by: disposeBag)
        
        endTimeLabel.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.timeSelectMode = .end
                self.updateUI()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUI() {
        switch timeSelectMode {
        case .start:
            startTimeLabel.textColor = .appBlue600
            endTimeLabel.textColor = .appGray700
            startPicker.isHidden = false
            endPicker.isHidden = true
        case .end:
            startTimeLabel.textColor = .appGray700
            endTimeLabel.textColor = .appBlue600
            startPicker.isHidden = true
            endPicker.isHidden = false
        }
    }
}

// MARK: - Method

extension MakeAppointmentTimeView {
    // 피커뷰 초기화 코드 추가 (시간대는 상관 없어요 버튼 생각)
    func reset() {
        timeSelectMode = .start
        
        startPicker.resetTime()
        endPicker.resetTime()
        
        updateUI()
    }
}

// MARK: - Reactive

/// 약속 시작 시간, 약속 종료 시간를 Reactive로 받습니다.
extension Reactive where Base: MakeAppointmentTimeView {
    var appointmentTimeRange: Observable<(String, String)> {
        return base.selectedTimeRange
    }
}
