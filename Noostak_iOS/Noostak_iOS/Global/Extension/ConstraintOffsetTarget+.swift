//
//  ConstraintOffsetTarget.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/27/25.
//

import SnapKit

public extension ConstraintOffsetTarget {
    var safeAreaTop: ConstraintOffsetTarget {
        return CGFloat.safeAreaTop
    }
    
    var safeAreaBottom: ConstraintOffsetTarget {
        return CGFloat.safeAreaBottom
    }
}
