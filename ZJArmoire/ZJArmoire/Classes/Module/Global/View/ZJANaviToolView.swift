//
//  ZJANaviToolView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/21.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJANaviToolView: UIView {
    
    typealias ConfirmCallback = () -> Void
    typealias CancelCallback = () -> Void
    
    private var confirmBlock: ConfirmCallback?
    private var cancelBlock: CancelCallback?
    
    public var isAutoDismiss: Bool = true
    
    init(title: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64))
        prepareUI()
        titleLabel.text = title
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func confirmCallback(block: @escaping () -> Void) {
        confirmBlock = block
    }
    
    public func cancelCallback(block: @escaping () -> Void) {
        cancelBlock = block
    }
    
    private func prepareUI() {
        backgroundColor = COLOR_MAIN_APP
        addSubview(titleLabel)
        addSubview(leftButton)
        addSubview(rightButton)
    }
    
    private func setupViewConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
        }
        
        leftButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(10)
            make.left.equalTo(10)
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(10)
            make.right.equalTo(-10)
        }
    }

    func show(animated: Bool) {
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
    }
    
    func dismiss(animated: Bool) {
        removeFromSuperview()
    }
    
    func didTappedCancelButton() {
        if isAutoDismiss == true {
            dismiss(animated: false)
        }
        cancelBlock?()
    }
    
    func didTappedConfirmButton() {
        if isAutoDismiss == true {
            dismiss(animated: false)
        }
        confirmBlock?()
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    public lazy var leftButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(didTappedCancelButton), for: .touchUpInside)
        return button
    }()
    
    public lazy var rightButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("确认", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(didTappedConfirmButton), for: .touchUpInside)
        return button
    }()
}
