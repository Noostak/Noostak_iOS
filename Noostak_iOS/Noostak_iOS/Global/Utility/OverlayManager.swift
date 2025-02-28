//
//  OverlayManager.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/28/25.
//

import UIKit
import SnapKit

final class OverlayManager {
    static let shared = OverlayManager()
    
    // MARK: - Popup
    private var popupWindow: UIWindow?
    private var currentPopup: AppPopUpViewController?

    // MARK: - Toast
    private var toastWindow: UIWindow?
    private var toastQueue: [(AppToastView, TimeInterval)] = []
    private var isShowingToast = false
    
    private init() {}
}

// MARK: PopUp
extension OverlayManager {
    /// 팝업 표시 (동시에 하나만 표시)
    func showPopup(
        contentViewController: AppPopUpViewController,
        windowLevel: UIWindow.Level = .alert + 1
    ) {
        // 이미 표시 중인 팝업이 있다면 기존 팝업 dismiss 후 새 팝업 표시
        if currentPopup != nil { dismissPopup() }
        
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
        
        self.popupWindow = makeUIWindow(scene: scene, windowLevel: windowLevel, viewController: contentViewController)
        self.currentPopup = contentViewController
        
        guard let popupView = contentViewController.view else { return }
        popupView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            popupView.alpha = 1
        }
    }
    
    /// 팝업 닫기
    func dismissPopup() {
        guard let popupWindow = popupWindow, let popupView = popupWindow.rootViewController?.view else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            popupView.alpha = 0
        }) { _ in
            popupWindow.isHidden = true
            self.popupWindow = nil
            self.currentPopup = nil
        }
    }
}

// MARK: Toast
extension OverlayManager {
    /// 토스트 표시 (큐에 쌓고 순차적으로 표시)
    func showToast(
        toastView: AppToastView,
        duration: TimeInterval = 2.0,
        windowLevel: UIWindow.Level = .statusBar
    ) {
        // 토스트 윈도우가 없으면 새로 생성
        if toastWindow == nil {
            guard let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
            
            self.toastWindow = makeUIWindow(scene: scene, windowLevel: windowLevel, viewController: nil)
        }
        
        // 큐에 추가
        toastQueue.append((toastView, duration))
        
        // 현재 토스트가 표시 중이 아닐 때만 새로 표시
        if !isShowingToast {
            showNextToast()
        }
    }
    
    /// 큐에서 다음 토스트를 표시합니다
    func showNextToast() {
        // 토스트 큐에 토스트 있을 때 다음으로
        guard !toastQueue.isEmpty else {
            isShowingToast = false
            toastWindow?.isHidden = true
            toastWindow = nil
            return
        }
        
        // 큐에서 토스트 표시 위한 준비
        isShowingToast = true
        let (toastView, duration) = toastQueue.removeFirst()
        guard let toastWindow, let containerView = toastWindow.rootViewController?.view else { return }
        
        toastView.alpha = 0
        containerView.addSubview(toastView)
        toastView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(toastWindow.safeAreaLayoutGuide).inset(80)
        }
        
        // 애니메이션 (페이드 인 -> 유지 -> 페이드 아웃)
        UIView.animate(withDuration: 0.25, animations: {
            toastView.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.dismissToast(toastView)
            }
        }
    }
    
    /// 각 오버레이 뷰에 맞는 UIWindow를 생성
    private func makeUIWindow(scene: UIWindowScene, windowLevel: UIWindow.Level, viewController: UIViewController?) -> UIWindow {

        let newWindow = UIWindow(windowScene: scene)
        newWindow.windowLevel = windowLevel
        
        let vc = viewController ?? UIViewController().then { $0.view.backgroundColor = .clear }
        newWindow.rootViewController = vc
        newWindow.makeKeyAndVisible()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissCurrentToast))
        vc.view.addGestureRecognizer(tapGesture)
        
        return newWindow
    }
    
    /// 특정 토스트 뷰를 닫고, 다음 토스트 표시
    func dismissToast(_ toastView: UIView) {
        UIView.animate(withDuration: 0.25, animations: {
            toastView.alpha = 0
        }) { _ in
            toastView.removeFromSuperview()
            self.showNextToast()
        }
    }
    
    /// 현재 표시되고 있는 토스트 뷰를 닫고, 다음 토스트 표시
    @objc private func dismissCurrentToast() {
        DispatchQueue.main.async {
            guard self.isShowingToast,
                  let toastWindow = self.toastWindow,
                  let containerView = toastWindow.rootViewController?.view,
                  let currentToast = containerView.subviews.first as? AppToastView else {
                return
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                currentToast.alpha = 0
            }, completion: { _ in
                currentToast.removeFromSuperview()
                self.showNextToast()
            })
        }
    }
}
