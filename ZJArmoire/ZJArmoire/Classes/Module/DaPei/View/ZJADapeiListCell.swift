//
//  ZJADapeiListCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/26.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJADapeiListCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(dpModel: ZJADapeiModel!, isSelector: Bool) {
        var cellImg: UIImage = UIImage()
        if let img = dpModel.cellImg {
            cellImg = img
            photoJointView.image = cellImg
        } else {
            DispatchQueue.global().async {
                cellImg = self.photoJointView.configPhotoView(photoList: dpModel.clothesList)
                DispatchQueue.main.async {
                    dpModel.cellImg = cellImg
                    self.photoJointView.image = cellImg
                }
            }
        }
        if isSelector == true {
            iconImageView.isHidden = false
        } else {
            iconImageView.isHidden = true
        }
    }
    
    func setupViewConstraints() {
        iconImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.top.equalTo(5)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
    }
    
    func prepareUI() {
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.addSubview(photoJointView)
        photoJointView.addSubview(iconImageView)
    }
    
    private lazy var photoJointView: ZJAPhotoJointView = {
        let jointView: ZJAPhotoJointView = ZJAPhotoJointView(frame: self.contentView.frame)
//        jointView.layer.cornerRadius = 5
        return jointView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "Dapei_已勾选"))
        return imgView
    }()
}
