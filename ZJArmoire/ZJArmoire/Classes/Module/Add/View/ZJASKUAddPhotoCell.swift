//
//  ZJASKUAddPhotoCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/11/30.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUAddPhotoCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
        setUpViewContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configCell(image: UIImage) {
        photoImageView.image = image
    }
    
    private func prepareUI() {
        contentView.addSubview(photoImageView)
    }
    
    private func setUpViewContraints() {
        photoImageView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(0)
        }
    }
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
}
