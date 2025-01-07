//
//  UIImagePickerController+.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/8/25.
//

import UIKit
import RxSwift
import RxCocoa


extension Reactive where Base: UIImagePickerController {
    /// `UIImagePickerController`의 미디어 선택 결과를 Observable로 노출
    ///
    /// 이 Observable은 이미지를 선택하거나 취소한 후 결과를 반환합니다.
    /// - Returns: 선택된 미디어 정보(`[UIImagePickerController.InfoKey: Any]`) 또는 완료 이벤트
    ///
    /// 사용 예시:
    /// ```swift
    /// let imagePicker = UIImagePickerController()
    /// imagePicker.sourceType = .camera
    ///
    /// imagePicker.rx.didFinishPickingMedia
    ///     .subscribe(onNext: { info in
    ///         if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
    ///             print("Picked image: \(image)")
    ///         }
    ///     }, onCompleted: {
    ///         print("Picker dismissed.")
    ///     })
    ///     .disposed(by: disposeBag)
    ///
    /// present(imagePicker, animated: true)
    /// ```
    public var didFinishPickingMedia: Observable<[UIImagePickerController.InfoKey: Any]> {
        return Observable.create { [weak base] observer in
            guard let picker = base else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let delegateProxy = RxImagePickerDelegateProxy.proxy(for: picker)
            let disposable = delegateProxy.didFinishPicking
                .subscribe(observer)
            
            return Disposables.create {
                disposable.dispose()
                picker.dismiss(animated: true)
            }
        }
    }
}

// MARK: - RxImagePickerDelegateProxy
final class RxImagePickerDelegateProxy: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate>, DelegateProxyType {
    
    // PublishSubject를 통해 Delegate 호출을 Rx로 노출
    let didFinishPicking = PublishSubject<[UIImagePickerController.InfoKey: Any]>()

    // DelegateProxy의 초기화
    init(imagePicker: UIImagePickerController) {
        super.init(parentObject: imagePicker, delegateProxy: RxImagePickerDelegateProxy.self)
    }
}


// MARK: - DelegateProxyType 구현
extension RxImagePickerDelegateProxy {
    
    static func registerKnownImplementations() {
        self.register { RxImagePickerDelegateProxy(imagePicker: $0) }
    }
    
    static func currentDelegate(for object: UIImagePickerController) -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
        object.delegate = delegate
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate 구현
extension RxImagePickerDelegateProxy: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        didFinishPicking.onNext(info)
        didFinishPicking.onCompleted()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        didFinishPicking.onCompleted()
    }
}

