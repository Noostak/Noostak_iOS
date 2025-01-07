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
    private let tapRelay = PublishRelay<Void>()
    private var likeStatusRelay = BehaviorRelay<Liked>(value: .unliked)
    private var likeCountRelay = BehaviorRelay<Int>(value: 0)
    
    struct Output {
        let tapEvent: Observable<Void>
    }
    
    // MARK: UI Components
    private let iconImageView = UIImageView()
    private let countLabel = UILabel()
    private lazy var likeStackView = UIStackView(arrangedSubviews: [iconImageView, countLabel])
    
    init() {
        super.init(frame: .zero)
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
            .bind(to: tapRelay)
            .disposed(by: disposeBag)

        likeStatusRelay
            .asObservable()
            .subscribe(onNext: { [weak self] status in
                guard let self = self else { return }
                self.iconImageView.image = (status == .liked) ? .icFilledHeart : .icUnfilledHeart
                self.countLabel.textColor = (status == .liked) ? .appBlack : .appGray600
            })
            .disposed(by: disposeBag)
        
        likeCountRelay
            .asObservable()
            .map {"\($0)"}
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension LikeButton {
    // MARK: External Binding
    func bind(likeStatus: Observable<Liked>, likeCount: Observable<Int>) -> Output {
        likeStatus
            .bind(to: likeStatusRelay)
            .disposed(by: disposeBag)

        likeCount
            .bind(to: likeCountRelay)
            .disposed(by: disposeBag)

        return Output(tapEvent: tapRelay.asObservable())
    }
}
