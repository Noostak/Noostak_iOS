//
//  ProfileImagePicker.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/7/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class ProfileImagePicker: UIView {
    
    // MARK: Properties
    fileprivate let tapGesture = UITapGestureRecognizer() // 전체 영역을 위한 탭 제스처
    
    // MARK: Views
    fileprivate let profileImageView = UIImageView(image: .imgProfileFilled)
    fileprivate let cameraButton = UIButton()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.makeCircular()
    }
    
    // MARK: setUpHierarchy
    private func setUpHierarchy() {
        [
            profileImageView,
            cameraButton
        ].forEach { self.addSubview($0) }
    }
    
    // MARK: setUpUI
    private func setUpUI() {
        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.clear.cgColor
        }
        
        cameraButton.do {
            $0.setImage(.icnProfileCamera, for: .normal)
            $0.isUserInteractionEnabled = true
        }
    }
    
    // MARK: setUpLayout
    private func setUpLayout() {
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(112)
        }
        
        cameraButton.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.size.equalTo(35)
        }
    }
}

// MARK: - Reactive Extension
extension Reactive where Base: ProfileImagePicker {
    /// UIImageView의 이미지를 ControlProperty로 노출
    var profileImage: ControlProperty<UIImage?> {
        return ControlProperty(
            values: base.profileImageView.rx.observe(\.image),
            valueSink: Binder(base) { profileImgPicker, image in
                if let image {
                    profileImgPicker.profileImageView.image = image
                    profileImgPicker.profileImageView.layer.borderColor = UIColor.appGray600.cgColor
                } else {
                    profileImgPicker.profileImageView.image = .imgProfileFilled
                    profileImgPicker.profileImageView.layer.borderColor = UIColor.clear.cgColor
                }
            }
        )
    }
    
    /// 탭 이벤트를 ControlEvent로 노출
    var tap: ControlEvent<Void> {
        let tapGesture = base.tapGesture.rx.event.map { _ in () }
        return ControlEvent(events: tapGesture)
    }
}
