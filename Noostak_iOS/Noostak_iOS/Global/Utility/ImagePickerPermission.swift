//
//  ImagePickerPermission.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/7/25.
//

import UIKit
import Photos
import RxSwift

/// 카메라 및 사진 라이브러리에 대한 권한을 확인하고 요청하는 유틸리티입니다.
struct ImagePickerPermission {
    
    /// 카메라 사용 권한을 확인하거나 요청합니다.
    /// - Returns: `Observable<Bool>`로 권한 여부를 반환합니다.
    ///   - `true`: 카메라 권한이 허용됨.
    ///   - `false`: 카메라 권한이 거부됨.
    /// - Example:
    /// ```swift
    /// ImagePickerPermission.checkCameraPermission()
    ///     .subscribe(onNext: { isAuthorized in
    ///         if isAuthorized {
    ///             print("카메라 권한 허용됨")
    ///         } else {
    ///             print("카메라 권한 거부됨")
    ///         }
    ///     })
    /// ```
    static func checkCameraPermission() -> Observable<Bool> {
        return Observable.create { observer in
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                observer.onNext(true)
                observer.onCompleted()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        observer.onNext(granted)
                        observer.onCompleted()
                    }
                }
            default:
                observer.onNext(false)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    /// 사진 라이브러리 사용 권한을 확인하거나 요청합니다.
    /// - Returns: `Observable<Bool>`로 권한 여부를 반환합니다.
    ///   - `true`: 사진 라이브러리 권한이 허용됨.
    ///   - `false`: 사진 라이브러리 권한이 거부됨.
    /// - Example:
    /// ```swift
    /// ImagePickerPermission.checkGalleryPermission()
    ///     .subscribe(onNext: { isAuthorized in
    ///         if isAuthorized {
    ///             print("사진 라이브러리 권한 허용됨")
    ///         } else {
    ///             print("사진 라이브러리 권한 거부됨")
    ///         }
    ///     })
    /// ```
    static func checkGalleryPermission() -> Observable<Bool> {
        return Observable.create { observer in
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            switch status {
            case .authorized, .limited:
                observer.onNext(true)
                observer.onCompleted()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                    DispatchQueue.main.async {
                        observer.onNext(newStatus == .authorized || newStatus == .limited)
                        observer.onCompleted()
                    }
                }
            default:
                observer.onNext(false)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
