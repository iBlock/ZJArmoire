//
//  ZJACameraEditActionView.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/10/19.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

protocol ZJACamereEditActionProtocol:NSObjectProtocol {
    func didTappedAgainCameraButton()
    func didTappedConfirmButton()
}

class ZJACameraEditActionView: UIView {
    
    private let confirmImage:UIImage! = UIImage(named: "Global_Confirm_Sel")
    private let againImage:UIImage! = UIImage(named: "Camera_again")
    weak var editImageActionDelegate:ZJACamereEditActionProtocol?
//    private let editImage:UIImage?

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
        addSubview(confirmButton)
        addSubview(againCameraButton)
    }
    
    private func setUpViewConstraints() {
        confirmButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        againCameraButton.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Event and Respone
    
    @objc func didTappedAgainCameraButton() {
        editImageActionDelegate?.didTappedAgainCameraButton()
    }
    
    @objc func didTappedConfirmButton() {
        editImageActionDelegate?.didTappedConfirmButton()
    }
    
    // MARK: - Lazy Method
    
    private lazy var confirmButton:UIButton = {
        let confirBtn:UIButton = UIButton(type: UIButtonType.custom)
        confirBtn.setBackgroundImage(self.confirmImage, for: .normal)
        confirBtn.addTarget(self, action: #selector(didTappedConfirmButton), for: .touchUpInside)
        
        return confirBtn
    }()
    
    private lazy var againCameraButton:UIButton = {
        let againBtn = UIButton(type: UIButtonType.custom)
        againBtn.setBackgroundImage(self.againImage, for: .normal)
        againBtn.addTarget(self, action: #selector(didTappedAgainCameraButton), for: .touchUpInside)
        
        return againBtn
    }()

}
