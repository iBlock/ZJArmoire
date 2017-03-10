//
//  ZJADefaultTodayDapeiCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/3.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJADefaultTodayDapeiCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func prepareUI() {
        contentView.addSubview(backGroundView)
        backGroundView.addSubview(titleLabel)
        backGroundView.addSubview(iconImgView)
    }
    
    private func setupViewConstraints() {
        backGroundView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.bottom.equalTo(0)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        iconImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(titleLabel.snp.left).offset(-10)
            make.size.equalTo(CGSize(width: 64, height: 62))
        }
    }
    
    private lazy var backGroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
//        view.backgroundColor = UIColor.colorWithHexString(hex: "fbfbfb")
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "快去添加搭配吧~~"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var iconImgView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "HOME_添加照片"))
        return imgView
    }()

}
