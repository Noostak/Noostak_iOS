//
//  SharePresenter.swift
//  Noostak_iOS
//
//  Created by 박민서 on 1/8/25.
//

import UIKit
import RxSwift

final class SharePresenter {
    
    /// 공유 화면을 표시하는 함수
    /// - Parameters:
    ///   - items: 공유할 항목 (텍스트, 이미지, URL 등)
    ///   - excludedActivityTypes: 제외할 Activity 타입
    ///   - sourceViewController: 공유 화면을 띄울 뷰 컨트롤러
    ///   - completion: 공유 완료/취소 콜백
    static func share(
        items: [Any],
        excludedActivityTypes: [UIActivity.ActivityType]? = nil,
        from sourceViewController: UIViewController,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        activityViewController.completionWithItemsHandler = { _, success, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(success))
            }
        }
        
        sourceViewController.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: Reactive Wrapping
extension SharePresenter {
    /// Reactive 확장 - 공유 화면 표시를 Observable로 반환
    /// - Parameters:
    ///   - items: 공유할 항목 (텍스트, 이미지, URL 등)
    ///   - excludedActivityTypes: 제외할 Activity 타입
    ///   - sourceViewController: 공유 화면을 띄울 뷰 컨트롤러
    /// - Returns: 공유 성공 여부를 방출하는 Observable
    static func share(
        items: [Any],
        excludedActivityTypes: [UIActivity.ActivityType]? = nil,
        from sourceViewController: UIViewController
    ) -> Observable<Bool> {
        return Observable.create { observer in
            share(items: items, excludedActivityTypes: excludedActivityTypes, from: sourceViewController) { result in
                switch result {
                    
                case .success(let success):
                    observer.onNext(success)
                    observer.onCompleted()
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
