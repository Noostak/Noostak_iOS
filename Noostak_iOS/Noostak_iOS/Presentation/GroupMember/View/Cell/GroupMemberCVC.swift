//
//  GroupMemberCVC.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/9/25.
//

import UIKit
import SnapKit
import Then
import ReactorKit

final class GroupMemberCVC: UICollectionViewCell, View {
    
    // MARK: Properties
    static let identifier = "GroupMemberCVC"
    var disposeBag = DisposeBag()
    
    // MARK: Views
    private let memberProfile = UIImageView()
    private let memberName = UILabel()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [memberProfile, memberName].forEach {
            self.addSubview($0)
        }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        memberProfile.do {
            $0.image = .imgProfileFilled
            $0.layer.cornerRadius = 30.5
        }
        
        memberName.do {
            $0.font = .PretendardStyle.c3_sb.font
            $0.textColor = .appGray900
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        memberProfile.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(61)
        }
        
        memberName.snp.makeConstraints {
            $0.top.equalTo(memberProfile.snp.bottom).offset(4)
            $0.centerX.equalTo(memberProfile)
        }
    }
}

extension GroupMemberCVC {
    func bind(reactor: GroupMemberCellReactor) {
        let user = reactor.currentState.user
        memberProfile.image = .imgProfileFilled //api 연결시 변경
        memberName.text = user.name
    }
}
