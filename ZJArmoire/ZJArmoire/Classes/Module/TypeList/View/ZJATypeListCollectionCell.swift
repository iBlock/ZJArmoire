//
//  ZJATypeListCollectionCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/1/16.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation

class ZJATypelistCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
        setUpViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configCell(clothesModel: ZJAClothesModel, isDelete: Bool) {
        var cellImg: UIImage
        if let img = clothesModel.cellImg {
            cellImg = img
        } else {
            cellImg = clothesModel.clothesImg.autoResizeImage(newSize: self.size)!
            clothesModel.cellImg = cellImg
        }
        typeImageView.image = cellImg
        
        if isDelete == true {
            selectorButton.isHidden = false
        } else {
            selectorButton.isHidden = true
        }
        
        if clothesModel.isSelector == true {
            selectorButton.setImage(UIImage(named: "photo_sel"), for: .normal)
        } else {
            selectorButton.setImage(UIImage(named: "photo_def"), for: .normal)
        }
    }
    
    private func prepareUI() {
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.addSubview(typeImageView)
        contentView.addSubview(selectorButton)
    }
    
    private func setUpViewConstraints() {
        typeImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        selectorButton.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(-10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    private lazy var typeImageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    public lazy var selectorButton: UIButton = {
        let deleteBtn = UIButton(type: UIButtonType.custom)
        deleteBtn.isHidden = true
        deleteBtn.isUserInteractionEnabled = false
        deleteBtn.setImage(UIImage(named: "photo_def"), for: .normal)
        return deleteBtn
    }()
}
