//
//  SchedulePickerLayout.swift
//  Noostak_iOS
//
//  Created by 오연서 on 1/10/25.
//

import UIKit

final class SchedulePickerLayout: UICollectionViewFlowLayout {
    private let fixedFirstColumnWidth: CGFloat = 42
    private let fixedFirstRowHeight: CGFloat = 36
    
    private var totalRows: Int = 0
    private var totalColumns: Int = 0
    private let minimumSpacing: CGFloat = 0
    
    func configure(totalRows: Int = 0, totalColumns: Int = 0) {
        self.totalRows = totalRows
        self.totalColumns = totalColumns
        invalidateLayout()
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        let remainingWidth = collectionView.bounds.width - fixedFirstColumnWidth - CGFloat(totalColumns - 1) * minimumSpacing
        let dynamicColumnWidth = remainingWidth / CGFloat(totalColumns - 1)
        let dynamicRowHeight = 32.0
        
        itemSize = CGSize(width: dynamicColumnWidth, height: dynamicRowHeight)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = .zero
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        attributes?.forEach { layoutAttribute in
            let indexPath = layoutAttribute.indexPath
            let column = indexPath.item % totalColumns
            let row = indexPath.item / totalColumns
            
            // 첫 번째 열의 너비 고정, 열 간 간격 조정
            if column == 0 {
                layoutAttribute.frame.size.width = fixedFirstColumnWidth
                layoutAttribute.frame.origin.x = 0
            } else { // 두 번째 열 이후
                let previousColumnRight = fixedFirstColumnWidth + CGFloat(column - 1) * (itemSize.width + minimumInteritemSpacing)
                layoutAttribute.frame.origin.x = previousColumnRight
            }
            
            // 첫 번째 행의 높이 고정, 행 간 간격 조정
            if indexPath.item < totalColumns {
                layoutAttribute.frame.size.height = fixedFirstRowHeight
                layoutAttribute.frame.origin.y = 0
            } else { // 두 번째 행 이후
                let previousRowBottom = fixedFirstRowHeight + CGFloat(row - 1) * (itemSize.height + minimumLineSpacing)
                layoutAttribute.frame.origin.y = previousRowBottom
            }
        }
        return attributes
    }
}
