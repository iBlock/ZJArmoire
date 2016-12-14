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
    
    public func configCell(image: UIImage, isEdit: Bool) {
//        photoImageView.image = image
        photoImageView.setImage(image, for: .normal)
        deleteButton.isHidden = !isEdit
    }
    
    private func prepareUI() {
        contentView.addSubview(photoImageView)
    }
    
    private func setUpViewContraints() {
        photoImageView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(0)
        }
        
        deleteButton.snp.makeConstraints { (make) in
            let size:CGSize = (UIImage(named: "Global_删除")?.size)!
            make.top.right.equalTo(0)
            make.size.equalTo(size)
        }
    }
    
    public lazy var photoImageView: UIButton = {
//        let imageView = UIImageView()
//        return imageView
        let button = UIButton(type: UIButtonType.custom)
        button.addSubview(self.deleteButton)
        return button
    }()
    
    public lazy var deleteButton: UIButton = {
        let deleteBtn = UIButton(type: UIButtonType.custom)
        deleteBtn.isHidden = true
        deleteBtn.setImage(UIImage(named: "Global_删除"), for: .normal)
        return deleteBtn
    }()
    
}
