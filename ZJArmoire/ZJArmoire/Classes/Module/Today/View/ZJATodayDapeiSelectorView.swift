//
//  ZJATodayDapeiSelectorView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/1/17.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

public enum ZJATodayDapeiSelectorType: Int {
    case exchangeImage
    case todayUseImage
}

class ZJATodayDapeiSelectorView: UIView {
    
    typealias PhotoSelectorCallback = (_ type: ZJATodayDapeiSelectorType) -> ()
    
    let photoSelectorViewHeight:CGFloat! = 120
    let takeImage:UIImage! = UIImage(named: "Camera_Take")
    let photoImage:UIImage! = UIImage(named: "Camera_Photo")
    
    var photoTypeClick:PhotoSelectorCallback?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        
        prepareUI()
        setUpViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tappedExchangeButton() {
        photoTypeClick?(.exchangeImage)
    }
    
    @objc func tappedTodayuseButton() {
        photoTypeClick?(.todayUseImage)
    }
    
    private func prepareUI() {
        backgroundColor = UIColor.white
        addSubview(mainView)
        let keywindow = UIApplication.shared.keyWindow
        keywindow?.addSubview(self)
    }
    
    private func setUpViewConstraints() {
        photoSelectorView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        takeButton.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.size.equalTo(self.takeImage.size)
            make.centerX.equalToSuperview()
        })
        
        takeButtonTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(takeButton.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(0)
            make.centerX.equalToSuperview()
        })
        
        takeButtonView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width:takeImage.size.width,height:85))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        photoButton.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.size.equalTo(photoImage.size)
            make.centerX.equalToSuperview()
        })
        
        photoButtonTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(photoButton.snp.bottom).offset(10)
            make.bottom.equalTo(0)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        })
        
        photoButtonView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width:photoImage.size.width,height:85))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private lazy var mainView:UIView = {
        let mainView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: self.photoSelectorViewHeight))
        mainView.backgroundColor = UIColor.white
        mainView.addSubview(self.photoSelectorView)
        return mainView
    }()
    
    private lazy var photoSelectorView:UIView = {
        let selectorView = UIView()
        selectorView.addSubview(self.takeButtonView)
        selectorView.addSubview(self.photoButtonView)
        return selectorView
    }()
    
    private lazy var takeButtonView:UIView = {
        let buttonView = UIView()
        buttonView.addSubview(self.takeButton)
        buttonView.addSubview(self.takeButtonTitle)
        return buttonView
    }()
    
    private lazy var photoButtonView:UIView = {
        let buttonView = UIView()
        buttonView.addSubview(self.photoButton)
        buttonView.addSubview(self.photoButtonTitle)
        return buttonView
    }()
    
    private lazy var takeButton:UIButton = {
        let takeButton = UIButton(type: UIButtonType.custom)
        takeButton.setBackgroundImage(self.takeImage, for: .normal)
        takeButton.addTarget(self, action: #selector(tappedExchangeButton), for: .touchUpInside)
        return takeButton
    }()
    
    private lazy var takeButtonTitle:UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "相机"
        titleLabel.textAlignment = .center
        titleLabel.textColor = COLOR_TEXT_LABEL
        return titleLabel
    }()
    
    private lazy var photoButton:UIButton = {
        let photoButton = UIButton(type: UIButtonType.custom)
        photoButton.setBackgroundImage(self.photoImage, for: .normal)
        photoButton.addTarget(self, action: #selector(tappedTodayuseButton), for: .touchUpInside)
        return photoButton
    }()
    
    private lazy var photoButtonTitle:UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "图库选择"
        titleLabel.textAlignment = .center
        titleLabel.textColor = COLOR_TEXT_LABEL
        return titleLabel
    }()
}
