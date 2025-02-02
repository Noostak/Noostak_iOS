//
//  ToastManager.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/2/25.
//

import UIKit
import SnapKit

final class ToastManager {
    static let shared = ToastManager()
    
    private init() {}

    private var overlayView: UIView?
    private var toastQueue: [(AppToastView, TimeInterval)] = []
    private var isShowingToast = false
        
    /// 토스트 메시지를 화면에 표시합니다.
        ///
        /// - Parameters:
        ///   - status: 표시할 토스트의 상태 (텍스트, 색상 등 지정)
        ///   - duration: 토스트가 화면에 유지되는 시간 (기본값: 2.0초)
        ///   - bottomFrom: 토스트가 화면 하단에서부터 얼마나 떨어져서 표시될지 지정 (기본값: 80pt)
    func showToast(status: AppToastView.Status, duration: TimeInterval = 2.0, bottomFrom: CGFloat = 80) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        // 기존 overlayView가 없으면 생성
        if overlayView == nil {
            self.overlayView = makeOverlayView(window: window)
        }
        
        // 토스트 뷰 생성 후 큐에 추가
        let toastView = makeToastView(status: status, bottomFrom: bottomFrom)
        toastQueue.append((toastView, duration))
        
        // 현재 토스트가 표시 중이 아닐 때만 새로 표시
        if !isShowingToast {
            showNextToast()
        }
    }
    
    /// 큐에서 다음 토스트를 표시합니다
    private func showNextToast() {
        // 토스트 큐에 토스트 있을 때 다음으로
        guard !toastQueue.isEmpty else {
            isShowingToast = false
            return
        }
        
        isShowingToast = true
        let (toastView, duration) = toastQueue.removeFirst() // FIFO
        
        // 애니메이션 (페이드 인 -> 유지 -> 페이드 아웃)
        UIView.animate(withDuration: 0.3, animations: {
            toastView.alpha = 1
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.dismissToast(toastView)
            }
        })
    }
    
    /// overlay 뷰가 없는 경우 새로운 뷰를 생성합니다
    private func makeOverlayView(window: UIWindow) -> UIView {
        let overlay = UIView(frame: window.bounds)
        overlay.backgroundColor = UIColor.clear
        window.addSubview(overlay)
        
        // 제스처 추가 (화면 터치 시 모든 토스트 닫기)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAllToasts))
        overlay.addGestureRecognizer(tapGesture)
        
        return overlay
    }
    
    /// 새로운 토스트 뷰를 생성합니다
    private func makeToastView(status: AppToastView.Status, bottomFrom: CGFloat) -> AppToastView {
        let toastView = AppToastView(status: status)
        toastView.alpha = 0 // clear 상태로 추가
        overlayView?.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(bottomFrom)
        }

        toastView.layoutIfNeeded()
        return toastView
    }
    
    /// 해당 토스트를 dimiss합니다 with Animation
    /// 큐에서 해당 토스트를 삭제하고, 다음 토스트를 실행합니다
    private func dismissToast(_ toastView: AppToastView) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                toastView.alpha = 0
            }, completion: { _ in
                toastView.removeFromSuperview()
                
                // 다음 토스트 실행
                if !self.toastQueue.isEmpty {
                    self.showNextToast()
                } else {
                    // 모든 토스트가 사라지면 overlayView도 제거
                    self.overlayView?.removeFromSuperview()
                    self.overlayView = nil
                    self.isShowingToast = false
                }
            })
        }
    }
    
    /// 큐에 쌓인 토스트를 일괄 삭제합니다
    @objc private func dismissAllToasts() {
        DispatchQueue.main.async {
            for (toast, _) in self.toastQueue {
                toast.removeFromSuperview()
            }
            self.toastQueue.removeAll()
            self.overlayView?.removeFromSuperview()
            self.overlayView = nil
            self.isShowingToast = false
        }
    }
}
