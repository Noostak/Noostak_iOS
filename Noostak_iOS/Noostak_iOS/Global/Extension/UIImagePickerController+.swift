//
//  UIImagePickerController.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/8/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIImagePickerController {
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

class RxImagePickerDelegateProxy: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate>, DelegateProxyType {
    
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

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension RxImagePickerDelegateProxy: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        didFinishPicking.onNext(info)
        didFinishPicking.onCompleted()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        didFinishPicking.onCompleted()
    }
}

