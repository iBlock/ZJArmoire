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
    let arrowImage = UIImage(named: "SKUAdd_Arrow_up")

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        prepareUI()
        setUpViewConstraints()
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
        typeLabel.text = type
    }
    
    private func prepareUI() {
        contentView.backgroundColor = UIColor.white
        arrowButton.setImage(arrowImage, for: .normal)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(arrowButton)
    }
    
    private func setUpViewConstraints() {
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.bottom.equalTo(0)
        })
        
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(70)
            make.top.bottom.equalTo(0)
        }
        
        arrowButton.snp.makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.size.equalTo(arrowImage!.size)
        })
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = COLOR_TEXT_LABEL
        titleLabel.text = "类别"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.textColor = UIColor.black
        typeLabel.font = UIFont.systemFont(ofSize: 15)
        typeLabel.textAlignment = .left
        return typeLabel
    }()

}
