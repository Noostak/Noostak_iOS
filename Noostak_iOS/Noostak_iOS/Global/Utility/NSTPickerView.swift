//
//  NSTPickerView.swift
//  Noostak_iOS
//
//  Created by 이명진 on 3/11/25.
//

import UIKit

import Then
import SnapKit

import RxSwift
import RxCocoa

final class NSTPickerView: UIPickerView {
    
    // MARK: - Properties
    
    fileprivate let selectedTimeRelay = BehaviorRelay<String>(value: "00:00")
    
    fileprivate let times: [String] = (0...24).map { hour -> String in
        String(format: "%02d:00", hour)
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIPickerViewDataSource

extension NSTPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times.count
    }
}

// MARK: - UIPickerViewDelegate

extension NSTPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let timeString = times[row]
        let components = timeString.split(separator: ":")
        let hourText = String(components[0])  // 시간
        let minuteText = String(components[1]) // 분 "00" 으로 고정
        
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fillEqually
            $0.spacing = 40
        }
        
        let hourLabel = UILabel().then {
            $0.text = hourText
            $0.font = .PretendardStyle.h3_sb.font
            $0.textColor = .appGray900
            $0.textAlignment = .center
        }
        
        let minuteLabel = UILabel().then {
            $0.text = minuteText
            $0.font = .PretendardStyle.h3_sb.font
            $0.textColor = .appGray900
            $0.textAlignment = .center
        }
        
        stackView.addArrangedSubview(hourLabel)
        stackView.addArrangedSubview(minuteLabel)
        
        return stackView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 48
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newTime = times[row]
        selectedTimeRelay.accept(newTime)
    }
    
}

// MARK: - Rx Extension
extension Reactive where Base: NSTPickerView {
    
    var time: ControlProperty<String> {
        let source = base.selectedTimeRelay.asObservable()
        
        let binder = Binder(base) { pickerView, newTime in
            guard let index = pickerView.times.firstIndex(of: newTime) else { return }
            
            pickerView.selectRow(index, inComponent: 0, animated: true)
            pickerView.selectedTimeRelay.accept(newTime)
        }
        
        return ControlProperty(values: source, valueSink: binder)
    }
}
