//
//  ZJAErrorView.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/21.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJAErrorView: UIView {
    
    typealias ErrorButtonClickCallback = () ->()
    
    var errorButtonClick:ErrorButtonClickCallback?
    
    var viewHeight:CGFloat! {
        get {
            layoutIfNeeded()
            return errorButton.y+errorButton.height
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        prepareUI()
        setUpViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        addSubview(errorImageView)
        addSubview(errorInfoTextLabel)
        addSubview(errorButton)
    }
    
    private func setUpViewConstraints() {
        errorImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(errorImage.size)
        }
        
        errorInfoTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(errorImageView.snp.bottom).offset(10)
            make.width.equalToSuperview()
        }
        
        errorButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 140, height: 44))
            make.centerX.equalToSuperview()
            make.top.equalTo(errorInfoTextLabel.snp.bottom).offset(10)
        }
    }
    
    // MARK: - Event and Respone
    
    @objc func didTappedErrorButton() {
        errorButtonClick?()
    }
    
    // MARK: - Setter and Getter
    
    var errorImage:UIImage! = UIImage(named:"Global_Emoticon_QiDai") {
        didSet{
            errorImageView.image = errorImage
            errorImageView.snp.updateConstraints { (make) in
                make.size.equalTo(errorImage.size)
            }
        }
    }
    
    var errorInfoText:String! = "该品类还没有东西哦，快点击添加吧！" {
        didSet {
            errorInfoTextLabel.text = errorInfoText
            errorInfoTextLabel.snp.updateConstraints { (make) in
                
            }
        }
    }
    
    var errorButtonText:String! = "添加" {
        didSet {
            errorButton.setTitle(errorButtonText, for: .normal)
        }
    }
    
    private lazy var errorImageView:UIImageView = {
        let imageView = UIImageView(image: self.errorImage)
        return imageView
    }()
    
    private lazy var errorInfoTextLabel:UILabel = {
        let infoLabel = UILabel()
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        infoLabel.text = self.errorInfoText
        infoLabel.textColor = COLOR_TEXT_LABEL
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        return infoLabel
    }()
    
    private lazy var errorButton:UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle(self.errorButtonText, for: .normal)
        let image:UIImage! = UIImage(named: "Global_Button")
        let imageInsets = UIEdgeInsetsMake(0, image.size.width/2-1, 0, image.size.height/2-1)
        let imageSel:UIImage! = UIImage(named: "Global_Button_Sel")
        let resizeImage = image.resizableImage(withCapInsets: imageInsets)
        let resizeImageSel = imageSel.resizableImage(withCapInsets: imageInsets)
        
        button.setBackgroundImage(resizeImage, for: .normal)
        button.setTitleColor(COLOR_MAIN_APP, for: .normal)
        button.setBackgroundImage(resizeImageSel, for: .highlighted)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.addTarget(self, action: #selector(didTappedErrorButton), for: .touchUpInside)
        
        return button
    }()

}
