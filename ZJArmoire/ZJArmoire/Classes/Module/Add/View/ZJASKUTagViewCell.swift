//
//  ZJASKUTagViewCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/12/1.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUTagViewCell: UITableViewCell {
    
    typealias reloadTableViewCallback = () -> Void
    typealias updateTagListCallback = (Array<Any>) -> Void
    
    var tagListViewHeight:CGFloat! = 40
    var reloadTableViewBlock:reloadTableViewCallback?
    var updateTagListBlock:updateTagListCallback?
    var tagLabel:UILabel!
    var tagView:SYTagListView!
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
    
//    public func getTagListViewHeight() -> CGFloat {
////        return tagListViewHeight
//        return self.tagView.frame.size.height
//    }
//    
    public func configTagCell(tagList:Array<Any>?) {
//        tagView.tagsArr = tagList
        let tagViewHeight = tagView.frame.size.height
        tagView.snp.updateConstraints { (make) in
            make.height.equalTo(tagViewHeight)
        }
    }
    
    private func prepareUI() {
        contentView.backgroundColor = UIColor.white
        tagView = makeTagView()
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
            make.height.equalTo(0)
        }
    }
    
    private func makeTagView() ->SYTagListView {
        let tagFrame = CGRect(x:0,y:0,width:SCREEN_WIDTH,height:0)
        let tagView:SYTagListView = SYTagListView(frame: tagFrame, andTags: [], isCanEdit: true)
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
        
        tagView.addSKUTag({ [weak self](tagNameList) in
            self?.updateTagListBlock?(tagNameList!)
        })
        return tagView
    }
    
//    lazy var tagView:SYTagListView = {
//        let tagFrame = CGRect(x:0,y:0,width:SCREEN_WIDTH,height:0)
//        let tagView:SYTagListView = SYTagListView(frame: tagFrame, andTags: [], isCanEdit: true)
//        tagView.tagBackgroundColor = COLOR_MAIN_APP
//        tagView.tagTextColor = UIColor.white
//        tagView.tagCornerRadius = 10.0
//        tagView.contentInsets = UIEdgeInsetsMake(10, 10, 5, 20)
//        tagView.autoItemHeightWithFontSize = false
//        tagView.tagBorderWidth = 0.5
//        tagView.tagBoarderColor = COLOR_MAIN_APP
//        tagView.selectTagBoarderColor = UIColor.black
//        tagView.itemHeight = 20
//        tagView.oneItemSpacing = 56
//        tagView.resetItemsFrame()
//        
//        tagView.addSKUTag({ [weak self](tagNameList) in
//            self?.updateTagListBlock?(tagNameList!)
//        })
//        
//        return tagView
//    }()

    private lazy var tagTitleView:UILabel = {
        let tagLabel:UILabel = UILabel()
        tagLabel.text = "标签"
        tagLabel.font = UIFont.systemFont(ofSize: 15)
        tagLabel.textColor = COLOR_TEXT_LABEL
        return tagLabel
    }()
}
