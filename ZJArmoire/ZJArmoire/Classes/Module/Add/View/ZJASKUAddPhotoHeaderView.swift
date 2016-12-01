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
        backgroundColor = UIColor.white
        let titleLabel = UILabel()
        titleLabel.text = "照片"
        titleLabel.textColor = COLOR_TEXT_LABEL
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.right.bottom.equalTo(0)
        })
    }

}
