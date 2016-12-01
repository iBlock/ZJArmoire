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
        switch index {
        case 0:
            typeButton.setImage(UIImage(named: "YiGui_Type_YiFu"), for: .normal)
        default:
            typeButton.setImage(UIImage(named: "YiGui_Type_YiFu"), for: .normal)
        }
    }
    
    private func prepareUI() {
        contentView.addSubview(typeButton)
    }
    
    private func setUpViewConstraints() {
        typeButton.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    private lazy var typeButton:UIButton = {
        let typeButton:UIButton = UIButton(type: UIButtonType.custom)
        typeButton.backgroundColor = UIColor.colorHex(hex: "00bb9c", alpha: 0.5)
        return typeButton
    }()
    
}
