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
            let image = UIImage(named: "SKUAdd_Arrow_down")
            arrowButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "SKUAdd_Arrow_up")
            arrowButton.setImage(image, for: .normal)
        }
    }
    
    public func configCell(type: String) {
        titleLabel.text = type
    }
    
    private func prepareUI() {
        contentView.backgroundColor = UIColor.white
        
        let image = UIImage(named: "SKUAdd_Arrow_up")
        arrowButton.setImage(image, for: .normal)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(arrowButton)
        
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.bottom.equalTo(0)
        })
        
        arrowButton.snp.makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.size.equalTo(image!.size)
        })
    }
    
    private func setUpViewConstraints() {
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.top.right.bottom.equalTo(0)
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = COLOR_TEXT_LABEL
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.textColor = COLOR_TEXT_LABEL
        typeLabel.font = UIFont.systemFont(ofSize: 15)
        typeLabel.textAlignment = .left
        return typeLabel
    }()

}
