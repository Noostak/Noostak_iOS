//
//  LikeButton.swift
//  Noostak_iOS
//
//  Created by 오연서 on 1/6/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

enum Liked {
    case liked
    case unliked
}

final class LikeButton: UIButton {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private var likeStatus = BehaviorRelay<Liked>(value: .unliked)
    private var likeCount = BehaviorRelay<Int>(value: 0)
    
    // MARK: UI Components
    private let iconImageView = UIImageView()
    private let countLabel = UILabel()
    private lazy var likeStackView = UIStackView(arrangedSubviews: [iconImageView, countLabel])
    
    init(likeStatus: Liked, likeCount: Int) {
        super.init(frame: .zero)
        self.likeStatus.accept(likeStatus)
        self.likeCount.accept(likeCount)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpHierarchy() {
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
        }
        
        countLabel.do {
            $0.font = .PretendardStyle.c2_sb.font
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
    
    private func bindUI() {
        self.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let status = self.likeStatus.value
                let count = self.likeCount.value
                self.likeStatus.accept((status == .liked) ? .unliked : .liked)
                self.likeCount.accept((status == .liked) ? count + 1 : max(0, count - 1))
            })
            .disposed(by: disposeBag)

        likeStatus
            .asObservable()
            .subscribe(onNext: { [weak self] status in
                guard let self = self else { return }
                self.iconImageView.image = (status == .liked) ? .icFilledHeart : .icUnfilledHeart
                self.countLabel.textColor = (status == .liked) ? .appBlack : .appGray600
            })
            .disposed(by: disposeBag)
        
        likeCount
            .asObservable()
            .map {"\($0)"}
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
