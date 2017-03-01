//
//  ZJADapeiDetailCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/1.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJADapeiDetailCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(clothesModel: ZJAClothesModel) {
        imgView.image = clothesModel.clothesImg
        typeLabel.text = CONFIG_YIGUI_TYPENAMES[clothesModel.type]
    }
    
    func prepareUI() {
        backgroundColor = UIColor.white
        contentView.addSubview(imgView)
        contentView.addSubview(typeLabel)
    }
    
    func setupViewConstraints() {
        imgView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(typeLabel.snp.top).offset(0)
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(30)
        }
    }
    
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = COLOR_TEXT_LABEL
        return label
    }()
}
