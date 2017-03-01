//
//  ZJASKUAddPhotoHeaderView.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/12/1.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUAddPhotoHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        contentView.backgroundColor = UIColor.white
        let titleLabel = UILabel()
        titleLabel.text = "照片"
        titleLabel.textColor = COLOR_TEXT_LABEL
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        contentView.addSubview(editButton)
        
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.bottom.equalTo(0)
            make.width.equalTo(100)
        })
        
        editButton.snp.makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.top.bottom.equalTo(0)
        })
    }
    
    public lazy var editButton: UIButton = {
        let editButton = UIButton(type: UIButtonType.custom)
        editButton.setTitle("删除", for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        editButton.setTitleColor(UIColor.colorWithHexString(hex: "e6454a"), for: .normal)
        return editButton
    }()

}
