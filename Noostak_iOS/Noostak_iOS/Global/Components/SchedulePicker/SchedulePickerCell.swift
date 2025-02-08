//
//  SchedulePickerCell.swift
//  Noostak_iOS
//
//  Created by 오연서 on 1/10/25.
//

import UIKit

final class SchedulePickerCell: UICollectionViewCell {
    
    static let identifier = "SchedulePickerCell"
    
    private var textLabel = UILabel()
    var isSelectedCell: Bool = false {
        didSet {
            backgroundColor = isSelectedCell ? .appBlue400 : .appWhite
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpHierarchy() {
        self.addSubview(textLabel)
    }
    
    private func setUpUI() {
        textLabel.do {
            $0.font = .PretendardStyle.c4_r.font
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.textColor = .appGray600
        }
    }
    
    private func setUpLayout() {
        textLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupCell() {
        self.backgroundColor = .appWhite
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.appGray200.cgColor
    }
    
    func configureHeader(for indexPath: IndexPath, dateHeaders: [String], timeHeaders: [String]) {
        let totalColumns = dateHeaders.count + 1
        let row = indexPath.item / totalColumns
        let column = indexPath.item % totalColumns
        
        /// dateHeader, timeHeader text binding
        if row == 0, column > 0 {
            self.textLabel.text = dateHeaders[column - 1]
        } else if column == 0, row > 0 {
            self.textLabel.text = "\(timeHeaders[row - 1])시"
        } else {
            self.textLabel.text = ""
        }
    }
    
    func configureTableRoundness(for indexPath: IndexPath, dateHeaders: [String], timeHeaders: [String]) {
        let totalRows = timeHeaders.count + 1
        let totalColumns = dateHeaders.count + 1
        
        let isTopLeft = indexPath.item == 0
        let isTopRight = indexPath.item == totalColumns - 1
        let isBottomLeft = indexPath.item == (totalRows - 1) * totalColumns
        let isBottomRight = indexPath.item == totalRows * totalColumns - 1
        
        if isTopLeft || isTopRight || isBottomLeft || isBottomRight {
            self.layer.cornerRadius = 10
            self.layer.masksToBounds = true
            switch true {
            case isTopLeft:
                self.layer.maskedCorners = [.layerMinXMinYCorner]
            case isTopRight:
                self.layer.maskedCorners = [.layerMaxXMinYCorner]
            case isBottomLeft:
                self.layer.maskedCorners = [.layerMinXMaxYCorner]
            case isBottomRight:
                self.layer.maskedCorners = [.layerMaxXMaxYCorner]
            default:
                break
            }
        } else {
            self.layer.cornerRadius = 0
        }
    }
}
