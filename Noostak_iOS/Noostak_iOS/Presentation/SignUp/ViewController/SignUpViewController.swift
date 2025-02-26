//
//  SignUpViewController.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/20/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import PhotosUI

final class SignUpViewController: UIViewController, View {

    // MARK: Properties
    var disposeBag = DisposeBag()
    private var phPickerConfig = PHPickerConfiguration()
    private lazy var phPicker = PHPickerViewController(configuration: phPickerConfig)
    
    // MARK: Views
    private let rootView = SignUpView()
    
    init(reactor: SignUpReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFoundation()
        hideKeyboardWhenTappedAround()
    }

    // MARK: setUpFoundation
    private func setUpFoundation() {
        phPickerConfig.filter = .images
        phPickerConfig.selectionLimit = 1
        phPicker.delegate = self
    }
    
    // MARK: bind
    func bind(reactor: SignUpReactor) {
        // MARK: Action
        // 사용자의 프로필 이미지 피커 버튼 탭
        rootView.profileImagePicker.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                self.present(self.phPicker, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 사용자의 이름 입력
        rootView.nameTextField.rx.text
            .distinctUntilChanged()
            .filter { $0 != reactor.currentState.name }
            .map { SignUpReactor.Action.inputName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 사용자의 텍스트필트 X 버튼 탭
        rootView.nameTextField.rx.deleteButtonTapped
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .map { SignUpReactor.Action.tapNameDeleteButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        // State의 이름 입력값 UI 반영
        reactor.state.map { $0.name }
            .distinctUntilChanged()
            .bind(to: rootView.nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        // State의 이름 텍스트필드 상태 UI 반영
        reactor.state.map { $0.nameTextFieldState }
            .distinctUntilChanged()
            .bind(to: rootView.nameTextField.rx.state)
            .disposed(by: disposeBag)
        
        // State의 프로필 이미지 UI 반영
        reactor.state.map { $0.imageData }
            .distinctUntilChanged()
            .compactMap { data in
                guard let data else { return nil }
                return UIImage(data: data)
            }
            .bind(to: rootView.profileImagePicker.rx.profileImage)
            .disposed(by: disposeBag)
        
        // State의 다음 버튼 상태 UI 반영
        reactor.state.map { $0.isNextButtonEnabled }
            .distinctUntilChanged()
            .bind(to: rootView.bottomButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

extension SignUpViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else { return }

        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            guard let self, let selectedImage = image as? UIImage else { return }
            
            if let imageData = selectedImage.pngData() {
                self.reactor?.action.onNext(.selectImage(imageData))
            }
        }
    }
}
