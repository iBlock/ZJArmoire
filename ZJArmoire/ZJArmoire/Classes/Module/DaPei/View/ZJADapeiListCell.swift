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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(photoList: [ZJAClothesModel]) {
        photoJointView.configPhotoView(photoList: photoList)
    }
    
    func setupViewConstraints() {

    }
    
    func prepareUI() {
        contentView.addSubview(photoJointView)
    }
    
    private lazy var photoJointView: ZJAPhotoJointView = {
        let jointView: ZJAPhotoJointView = ZJAPhotoJointView(frame: self.contentView.frame)
        return jointView
    }()
}
