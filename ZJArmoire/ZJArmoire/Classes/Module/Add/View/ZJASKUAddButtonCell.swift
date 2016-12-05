//
//  ZJASKUAddButtonCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/12/1.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUAddButtonCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
        setUpViewContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        contentView.addSubview(addPhotoButton)
    }
    
    private func setUpViewContraints() {
        addPhotoButton.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(0)
        }
    }
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "Global_Add2"), for: .normal)
        button.layer.borderColor = COLOR_BORDER_LINE.cgColor
        button.layer.borderWidth = 1
        button.isUserInteractionEnabled = false
        return button
    }()

}
