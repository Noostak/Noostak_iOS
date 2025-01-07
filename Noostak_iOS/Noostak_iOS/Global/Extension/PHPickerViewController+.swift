//
//  PHPickerViewController+.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/8/25.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI


extension Reactive where Base: PHPickerViewController {
    /// `PHPickerViewController`의 선택 결과를 Observable로 노출
    ///
    /// 이 Observable은 사용자가 사진을 선택하거나 취소한 후 결과를 반환합니다.
    /// - Returns: `[PHPickerResult]` 배열 또는 완료 이벤트
    ///
    /// 사용 예시:
    /// ```swift
    /// let configuration = PHPickerConfiguration()
    /// let picker = PHPickerViewController(configuration: configuration)
    ///
    /// picker.rx.didFinishPicking
    ///     .subscribe(onNext: { results in
    ///         guard let firstResult = results.first,
    ///               firstResult.itemProvider.canLoadObject(ofClass: UIImage.self) else {
    ///             print("No image selected")
    ///             return
    ///         }
    ///
    ///         firstResult.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
    ///             if let image = object as? UIImage {
    ///                 print("Selected image: \(image)")
    ///             }
    ///         }
    ///     }, onCompleted: {
    ///         print("Picker dismissed.")
    ///     })
    ///     .disposed(by: disposeBag)
    ///
    /// present(picker, animated: true)
    /// ```
    public var didFinishPicking: Observable<[PHPickerResult]> {
        return Observable.create { [weak base] observer in
            guard let picker = base else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let delegateProxy = RxPHPickerDelegateProxy.proxy(for: picker)
            let disposable = delegateProxy.didFinishPicking
                .subscribe(observer)
            
            return Disposables.create {
                disposable.dispose()
                picker.dismiss(animated: true)
            }
        }
    }
}

// MARK: - RxPHPickerDelegateProxy
final class RxPHPickerDelegateProxy: DelegateProxy<PHPickerViewController, PHPickerViewControllerDelegate>, DelegateProxyType {
    
    /// 사진 선택 결과를 PublishSubject로 노출
    let didFinishPicking = PublishSubject<[PHPickerResult]>()
    
    /// DelegateProxy 초기화
    init(picker: PHPickerViewController) {
        super.init(parentObject: picker, delegateProxy: RxPHPickerDelegateProxy.self)
    }
    
    
}

// MARK: - DelegateProxyType 구현
extension RxPHPickerDelegateProxy {
    
    static func registerKnownImplementations() {
        self.register { RxPHPickerDelegateProxy(picker: $0) }
    }
    
    static func currentDelegate(for object: PHPickerViewController) -> PHPickerViewControllerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: PHPickerViewControllerDelegate?, to object: PHPickerViewController) {
        object.delegate = delegate
    }
}

// MARK: PHPickerViewControllerDelegate 구현
extension RxPHPickerDelegateProxy: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        didFinishPicking.onNext(results)
        didFinishPicking.onCompleted()
    }
}
