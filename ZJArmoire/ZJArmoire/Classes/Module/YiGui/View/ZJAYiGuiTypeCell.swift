//
//  ZJAYiGuiTypeCell.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/17.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJAYiGuiTypeCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
        setUpViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configCell(image: String, title: String, typeCount: String) {
        typeImageView.image = UIImage(named: image)
        typeLabel.text = title
        typeCountLabel.text = typeCount
    }
    
    private func prepareUI() {
        contentView.addSubview(yiGuiTypeView)
    }
    
    private func setUpViewConstraints() {
        yiGuiTypeView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        typeImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(CGFloat(-40/2))
            make.size.equalTo(CGSize(width:100,height:100))
        }
        
        typeInfoView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(40)
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(50)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        typeCountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.width.equalTo(30)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }
    
    private lazy var yiGuiTypeView:UIView = {
        let typeView = UIView()
        typeView.layer.cornerRadius = 5
        typeView.backgroundColor = UIColor.colorHex(hex: "00bb9c", alpha: CGFloat(0.3))
        typeView.layer.masksToBounds = true
        
        typeView.addSubview(self.typeImageView)
        typeView.addSubview(self.typeInfoView)
        
        return typeView
    }()
    
    private lazy var typeInfoView:UIView = {
        let infoView = UIView()
        infoView.backgroundColor = UIColor.white
        infoView.addSubview(self.typeLabel)
        infoView.addSubview(self.typeCountLabel)
        return infoView
    }()
    
    private lazy var typeLabel:UILabel = {
        var typeLabel = UILabel()
        typeLabel.textColor = COLOR_TEXT_LABEL
        typeLabel.textAlignment = .left
        return typeLabel
    }()
    
    private lazy var typeCountLabel:UILabel = {
        var countLabel = UILabel()
        countLabel.textColor = COLOR_TEXT_LABEL
        countLabel.textAlignment = .right
        return countLabel
    }()
    
    private lazy var typeImageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
}
