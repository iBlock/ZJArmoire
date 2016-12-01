//
//  ZJASKUTypeHeaderView.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/12/1.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUTypeHeaderView: UITableViewHeaderFooterView {
    
    let arrowButton = UIButton(type: UIButtonType.custom)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configHeaderView(isClickArrowButton:Bool) {
        if isClickArrowButton == true {
            let image = UIImage(named: "SKUAdd_Arrow_up")
            arrowButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "SKUAdd_Arrow_down")
            arrowButton.setImage(image, for: .normal)
        }
    }
    
    private func prepareUI() {
        backgroundColor = UIColor.white
        
        let titleLabel = UILabel()
        titleLabel.text = "分类    上装"
        titleLabel.textColor = COLOR_TEXT_LABEL
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .left
        
        let image = UIImage(named: "SKUAdd_Arrow_up")
        arrowButton.setImage(image, for: .normal)
//        arrowButton.addTarget(self, action: #selector(didTappendArrowButton(sender:)), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(arrowButton)
        
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.right.bottom.equalTo(0)
        })
        
        arrowButton.snp.makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.size.equalTo(image!.size)
        })
    }

}
