//
//  ZJADapeiDetailFooterView2.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/3.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJADapeiDetailFooterView2: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareUI() {
        addSubview(confirmButton)
    }
    
    func setupViewConstraints() {
        confirmButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100, height: 44))
            make.center.equalToSuperview()
        }
    }
    
    public lazy var confirmButton:UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("今天穿", for: .normal)
        let image:UIImage! = UIImage(named: "Global_Button")
        let imageInsets = UIEdgeInsetsMake(0, image.size.width/2-1, 0, image.size.height/2-1)
        let imageSel:UIImage! = UIImage(named: "Global_Button_Sel")
        let resizeImage = image.resizableImage(withCapInsets: imageInsets)
        let resizeImageSel = imageSel.resizableImage(withCapInsets: imageInsets)
        
        button.setBackgroundImage(resizeImage, for: .normal)
        button.setTitleColor(COLOR_MAIN_APP, for: .normal)
        button.setBackgroundImage(resizeImageSel, for: .highlighted)
        button.setTitleColor(UIColor.white, for: .highlighted)
        
        return button
    }()
}
