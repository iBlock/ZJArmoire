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
    
    public func configCell(image: UIImage) {
        typeImageView.image = image
    }
    
    private func prepareUI() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(typeImageView)
    }
    
    private func setUpViewConstraints() {
        typeImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var typeImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10.0
        return imageView
    }()
}
