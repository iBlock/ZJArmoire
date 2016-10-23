//
//  ZJAPhotoSelectorView.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/22.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

public enum ZJAPhotoSelectorType: Int {
    case takeImage
    case selectorImage
}

class ZJAPhotoSelectorView: UIView {
    
    typealias PhotoSelectorCallback = (_ type: ZJAPhotoSelectorType) -> ()
    
    let photoSelectorViewHeight:CGFloat! = 120
    let takeImage:UIImage! = UIImage(named: "Camera_Take")
    let photoImage:UIImage! = UIImage(named: "Camera_Photo")
    
    var photoTypeClick:PhotoSelectorCallback?

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        
        prepareUI()
        setUpViewConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show() {
        alpha = 0.0
        let keywindow = UIApplication.shared.keyWindow
        keywindow?.addSubview(self)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { 
            self.alpha = 0.5
            var frame = self.mainView.frame
            frame.origin.y -= self.photoSelectorViewHeight
            self.mainView.frame = frame
            }) { (finished) in
                self.alpha = 1
                self.backgroundColor = UIColor.colorHex(hex: "000000", alpha: 0.5)
        }
    }
    
    public func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { 
            self.alpha = 0.0
            var frame = self.mainView.frame
            frame.origin.y += self.photoSelectorViewHeight
            self.mainView.frame = frame
            }) { (finished) in
                self.mainView.removeFromSuperview()
                self.removeFromSuperview()
        }
    }
    
    @objc func tappedTakeButton() {
        photoTypeClick?(.takeImage)
        dismiss()
    }
    
    @objc func tappedPhotoButton() {
        photoTypeClick?(.selectorImage)
        dismiss()
    }
    
    private func prepareUI() {
        backgroundColor = UIColor.colorHex(hex: "000000", alpha: 1)
        addSubview(mainView)
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
        takeButton.addTarget(self, action: #selector(tappedTakeButton), for: .touchUpInside)
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
        photoButton.addTarget(self, action: #selector(tappedPhotoButton), for: .touchUpInside)
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

extension ZJAPhotoSelectorView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isKind(of: UIButton.self))! {
            return false
        }
        
        return true
    }
}
