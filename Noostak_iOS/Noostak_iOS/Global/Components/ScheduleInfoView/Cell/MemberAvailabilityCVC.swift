//
//  MemberAvailabilityCVC.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/11/25.
//

import UIKit
import SnapKit
import Then
import ReactorKit

final class MemberAvailabilityCVC: UICollectionViewCell, View {
    
    // MARK: Properties
    static let identifier = "MemberAvailabilityCVC"
    var disposeBag = DisposeBag()
    
    // MARK: Views
    var chip = MemberAvailabilityChip(name: "", status: .available)
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        self.addSubview(chip)
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        chip.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MemberAvailabilityCVC {
    func bind(reactor: MemberAvailabilityCellReactor) {
        self.chip.update(name: reactor.currentState.user.name, status: reactor.currentState.status)
    }
}
