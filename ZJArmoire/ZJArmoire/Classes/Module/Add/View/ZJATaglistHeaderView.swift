//
//  ZJATaglistHeaderView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/24.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJATaglistHeaderView: SYTagListView {
    
    var topLine: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame, andTags: [], isCanEdit: true)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareUI() {
        backgroundColor = UIColor.white
        addSubview(self.tagTitleView)
        tagBackgroundColor = COLOR_MAIN_APP
        tagTextColor = UIColor.white
        tagCornerRadius = 10.0
        contentInsets = UIEdgeInsetsMake(10, 10, 5, 20)
        autoItemHeightWithFontSize = false
        tagBorderWidth = 0.5
        tagBoarderColor = COLOR_MAIN_APP
        selectTagBoarderColor = UIColor.black
        itemHeight = 20
        oneItemSpacing = 56
        resetItemsFrame()
        
        topLine = UIView()
        topLine.backgroundColor = COLOR_BORDER_LINE
        addSubview(topLine)
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = COLOR_BORDER_LINE
        addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        })
        
        self.tagTitleView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(0)
            make.size.equalTo(CGSize(width:40, height:40))
        }
        
        topLine.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(0.5)
        })
    }
    
    private lazy var tagTitleView:UILabel = {
        let tagLabel:UILabel = UILabel()
        tagLabel.text = "标签"
        tagLabel.font = UIFont.systemFont(ofSize: 16)
        tagLabel.textColor = COLOR_TEXT_LABEL
        return tagLabel
    }()

}
