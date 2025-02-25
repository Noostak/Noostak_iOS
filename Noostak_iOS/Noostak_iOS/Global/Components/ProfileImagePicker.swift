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

// MARK: Component Interface
protocol ProfileImagePickerProtocol: UIView {
    /// profileImage getter
    var profileImage: UIImage { get }
    /// profileImage setter
    func setProfileImageView(with image: UIImage?)
    /// tapGesture getter
    var tapGesture: UITapGestureRecognizer { get }
}

final class ProfileImagePicker: UIView {
    // 외부로 표시 + 내부에서만 사용 이 겹치는 프로퍼티의 경우, 내부 프로퍼티에 `_`를 추가했습니다
    
    // MARK: Properties
    private let _tapGesture = UITapGestureRecognizer() // 전체 영역을 위한 탭 제스처
    
    // MARK: Views
    private let _profileImage = UIImage(resource: .imgProfileFilled)
    private lazy var profileImageView = UIImageView(image: _profileImage)
    private let cameraButton = UIButton()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpUI()
        setUpLayout()
        addGestureRecognizer(_tapGesture)
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
            $0.isUserInteractionEnabled = false
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

// MARK: - Interface Extension
extension ProfileImagePicker: ProfileImagePickerProtocol {
    var profileImage: UIImage {
        return self._profileImage
    }
    
    func setProfileImageView(with profileImage: UIImage?) {
        if let profileImage {
            profileImageView.image = profileImage
            profileImageView.layer.borderColor = UIColor.appGray600.cgColor
        } else {
            profileImageView.image = .imgProfileFilled
            profileImageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    var tapGesture: UITapGestureRecognizer {
        return self._tapGesture
    }
}

// MARK: - Reactive Extension
extension Reactive where Base: ProfileImagePickerProtocol {
    /// UIImageView의 이미지를 ControlProperty로 노출
    var profileImage: ControlProperty<UIImage> {
        return ControlProperty(
            values: base.profileImage.rx.observe(\.self),
            valueSink: Binder(base) { base, image in
                base.setProfileImageView(with: image)
            }
        )
    }
    
    /// 탭 이벤트를 ControlEvent로 노출
    var tap: ControlEvent<Void> {
        let tapGesture = base.tapGesture.rx.event.map { _ in () }
        return ControlEvent(events: tapGesture)
    }
}
