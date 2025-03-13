//
//  AppPopUpViewController.swift
//  Noostak_iOS
//
//  Created by 박민서 on 3/4/25.
//

import UIKit
import SnapKit

final class AppPopUpViewController: UIViewController {
    
    // MARK: Views
    private let popUpView: AppPopUpView
    
    init(popUpView: AppPopUpView) {
        self.popUpView = popUpView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appBlack.withAlphaComponent(0.6)
        setUpHierarchy()
        setUpLayout()
    }
    
    private func setUpHierarchy() {
        self.view.addSubview(popUpView)
    }
    
    private func setUpLayout() {
        popUpView.snp.makeConstraints {
            $0.width.equalTo(274)
            $0.height.equalTo(144)
            $0.center.equalToSuperview()
        }
    }
}
