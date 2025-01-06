//
//  LikeButton.swift
//  Noostak_iOS
//
//  Created by 오연서 on 1/6/25.
//

import UIKit
import SnapKit
import Then

enum Liked {
    case liked
    case unliked
}

final class LikeButton: UIButton {
    
    // MARK: Properties
    private var likeStatus: Liked = .unliked
    private var likeCount = 0
    
    // MARK: UI Components
    private let iconImageView = UIImageView()
    private let countLabel = UILabel()
    private let likeStackView = UIStackView()
    
    init(likeStatus: Liked, likeCount: Int) {
        super.init(frame: .zero)
        self.likeStatus = likeStatus
        self.likeCount = likeCount
        setUpHierarchy()
        setUpUI()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpHierarchy() {
        [iconImageView, countLabel].forEach {
            likeStackView.addArrangedSubview($0)
        }
        self.addSubview(likeStackView)
    }
    
    private func setUpUI() {
        likeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .center
        }
        
        iconImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = (likeStatus == .liked) ? .icFilledHeart : .icUnfilledHeart
        }
        
        countLabel.do {
            $0.font = .PretendardStyle.c2_sb.font
            $0.text = "\(likeCount)"
            $0.textColor = (likeStatus == .liked) ? .appBlack : .appGray600
        }
        
        self.do {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.backgroundColor = .appWhite
        }
    }
    
    private func setUpLayout() {
        likeStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(13)
            $0.verticalEdges.equalToSuperview().inset(6)
        }
        
        self.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
    }
}
