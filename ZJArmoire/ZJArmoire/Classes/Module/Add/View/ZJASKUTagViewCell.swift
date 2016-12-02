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
            make.size.equalTo(CGSize(width:50, height:40))
        }
        
        tagView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    private lazy var tagView:SYTagListView = {
        let tagView:SYTagListView = SYTagListView(frame: self.bounds, andTags: ["hello","word"])
        tagView.tagBackgroundColor = UIColor.colorHex(hex: "00bb9c", alpha: 1)
        tagView.tagTextColor = UIColor.white
        tagView.tagCornerRadius = 10.0
        tagView.contentInsets = UIEdgeInsetsMake(10, 0, 5, 0)
        tagView.autoItemHeightWithFontSize = false
        tagView.itemHeight = 20
        tagView.oneItemSpacing = 56
        tagView.isClickEnable = false
        
        return tagView
    }()

    private lazy var tagTitleView:UILabel = {
        let tagLabel:UILabel = UILabel()
        tagLabel.text = "标签"
        tagLabel.backgroundColor = UIColor.yellow
        tagLabel.font = UIFont.systemFont(ofSize: 15)
        tagLabel.textColor = COLOR_TEXT_LABEL
        return tagLabel
    }()
}
