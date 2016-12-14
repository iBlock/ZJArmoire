//
//  ZJAPopView.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/12/12.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJAPopView: UIImageView {
    
    var popImage:UIImage? {
        didSet {
            self.image = popImage
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
        setUpViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show() {
        alpha = 0.5
        transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(didStopPopAnimation))
        UIView.setAnimationDuration(0.15)
        transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        alpha = 1.0
        UIView.commitAnimations()
    }
    
    @objc func didStopPopAnimation() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.1)
        transform = .identity
        UIView.commitAnimations()
    }
    
    private func prepareUI() {
        let popImage = UIImage(named: "Global_QiPao_you")
        image = popImage
        addSubview(self.popTitle)
    }
    
    private func setUpViewConstraints() {
        popTitle.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    private lazy var popTitle:UILabel = {
        let label = UILabel()
        label.text = "删除"
        label.textColor = COLOR_TEXT_LABEL
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
}
