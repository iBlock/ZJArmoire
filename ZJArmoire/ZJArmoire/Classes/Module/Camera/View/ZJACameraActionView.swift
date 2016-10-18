//
//  ZJACameraActionView.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/10/18.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

protocol ZJACameraActionViewDelegate:NSObjectProtocol {
    func didTappedCancelButton()
    func didTappedCameraButton()
}

class ZJACameraActionView: UIView {
    
    let cameraImage:UIImage! = UIImage(named: "Global_Camera")
    let cancelImage:UIImage! = UIImage(named: "Global_Cancel_Sel")
    
    weak var actionViewDelegate:ZJACameraActionViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
        setUpViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        backgroundColor = UIColor.white
        addSubview(cameraButton)
        addSubview(cancelButton)
    }
    
    private func setUpViewConstraints() {
        cameraButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(cameraImage.size)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.size.equalTo(cancelImage.size)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Event and Respone
    
    @objc private func didTappedCancelButton(sender:UIButton) {
        actionViewDelegate?.didTappedCancelButton()
    }
    
    @objc private func didTappedCameraButton(sender:UIButton) {
        actionViewDelegate?.didTappedCameraButton()
    }
    
    // MARK: - Lazy
    
    private lazy var cameraButton:UIButton = {
        let actionButton = UIButton(type: UIButtonType.custom)
        actionButton.setBackgroundImage(self.cameraImage, for: .normal)
        actionButton.addTarget(self, action: #selector(didTappedCameraButton(sender:)), for: .touchUpInside)
        return actionButton
    }()
    
    private lazy var cancelButton:UIButton = {
        let cancelBtn = UIButton(type: UIButtonType.custom)
        cancelBtn.setBackgroundImage(self.cancelImage, for: .normal)
        cancelBtn.addTarget(self, action: #selector(didTappedCancelButton(sender:)), for: .touchUpInside)
        return cancelBtn
    }()

}
