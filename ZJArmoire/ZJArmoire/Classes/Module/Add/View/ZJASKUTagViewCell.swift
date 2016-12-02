//
//  ZJASKUTagViewCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/12/1.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUTagViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareUI()
        setUpViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func prepareUI() {
        contentView.backgroundColor = UIColor.white
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = COLOR_TABLE_LINE
        contentView.addSubview(tagTitleView)
        contentView.addSubview(tagView)
        contentView.addSubview(bottomLine)
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(0.5)
        }
    }
    
    private func setUpViewConstraints() {
        tagTitleView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(0)
            make.size.equalTo(CGSize(width:40, height:40))
        }
        
        tagView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    private lazy var tagView:SYTagListView = {
        let tagView:SYTagListView = SYTagListView(canEdit: CGRect(x:0,y:0,width:SCREEN_WIDTH,height:0))
        tagView.tagBackgroundColor = COLOR_MAIN_APP
        tagView.tagTextColor = UIColor.white
        tagView.tagCornerRadius = 10.0
        tagView.contentInsets = UIEdgeInsetsMake(10, 10, 5, 20)
        tagView.autoItemHeightWithFontSize = false
        tagView.tagBorderWidth = 0.5
        tagView.tagBoarderColor = COLOR_MAIN_APP
        tagView.selectTagBoarderColor = UIColor.black
        tagView.itemHeight = 20
        tagView.oneItemSpacing = 56
        tagView.resetItemsFrame()
        
        return tagView
    }()

    private lazy var tagTitleView:UILabel = {
        let tagLabel:UILabel = UILabel()
        tagLabel.text = "标签"
        tagLabel.font = UIFont.systemFont(ofSize: 15)
        tagLabel.textColor = COLOR_TEXT_LABEL
        return tagLabel
    }()
}
