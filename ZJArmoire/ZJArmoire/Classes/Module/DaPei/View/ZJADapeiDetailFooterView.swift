//
//  ZJADapeiDetailFooterView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/1.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJADapeiDetailFooterView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareUI() {
        addSubview(titleLabel)
    }
    
    func setupViewConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func didTappedConfirmButton() {
        
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = COLOR_TEXT_LABEL
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "------ End ------"
        label.textAlignment = .center
        return label
    }()
    
}
