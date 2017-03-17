//
//  ZJASKUTypeCollectionCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/12/1.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUTypeCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
        setUpViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configCell(index:NSInteger) {
        let typeImage = (CONFIG_YIGUI_TYPEIMAGES as NSArray).object(at: index)
        typeButton.setImage(UIImage(named: typeImage as! String), for: .normal)
    }
    
    private func prepareUI() {
        backgroundColor = UIColor.colorHex(hex: "0fd4c2", alpha: 0.5)
        contentView.addSubview(typeButton)
    }
    
    private func setUpViewConstraints() {
        typeButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
            make.bottom.right.equalTo(-10)
        }
    }
    
    private lazy var typeButton:UIButton = {
        let typeButton:UIButton = UIButton(type: UIButtonType.custom)
        typeButton.isUserInteractionEnabled = false
        return typeButton
    }()
    
}
