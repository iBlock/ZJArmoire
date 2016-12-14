//
//  ZJASKUAddTableView.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/11/29.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

protocol ZJASKUAddTableViewDelegate:NSObjectProtocol {
    func didTappedAddPhotoButton()
}

class ZJASKUAddTableView: UITableView {
    
    let ZJASKUAddCellIdentifier = "ZJASKUAddCellIdentifier"
    let ZJASKUTypeViewCellIdentifier = "ZJASKUTypeViewCellIdentifier"
    let ZJASKUAddPhotoHeaderViewIdentifier = "ZJASKUAddPhotoHeaderViewIdentifier"
    let ZJASKUTypeHeaderViewIdentifier = "ZJASKUTypeHeaderViewIdentifier"
    let ZJASKUTagCellIdentifier = "ZJASKUTagCellIdentifier"
    
    weak var skuDelegate:ZJASKUAddTableViewDelegate?
    
    var isClickTypeArrowButton:Bool = false
    var isAddTarget:Bool = false
    var tagListFrame:CGRect! = CGRect(x:0,y:0,width:SCREEN_WIDTH,height:45)
    
    var currentSKUItemModel:ZJASKUItemModel?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        prepareUI()
        setUpViewConstraints()
    }
    
    deinit {
        print("%s已释放", NSStringFromClass(self.classForCoder))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareUI() -> Void {
        if skuItemArray.count > 0 {
            currentSKUItemModel = skuItemArray.object(at: 0) as? ZJASKUItemModel
        }
        backgroundColor = COLOR_MAIN_BACKGROUND
        estimatedRowHeight = 85
        estimatedSectionHeaderHeight = 40
        delegate = self
        dataSource = self
        separatorStyle = .none
        register(ZJASKUAddCell.self, forCellReuseIdentifier: ZJASKUAddCellIdentifier)
        register(ZJASKUTypeViewCell.self, forCellReuseIdentifier: ZJASKUTypeViewCellIdentifier)
        register(ZJASKUAddPhotoHeaderView.self, forHeaderFooterViewReuseIdentifier: ZJASKUAddPhotoHeaderViewIdentifier)
        register(ZJASKUTypeHeaderView.self, forHeaderFooterViewReuseIdentifier: ZJASKUTypeViewCellIdentifier)
        register(ZJASKUTagViewCell.self, forCellReuseIdentifier: ZJASKUTagCellIdentifier)
    }
    
    func setUpViewConstraints() -> Void {
        
    }
    
    lazy var skuItemArray:NSArray = {
        let dataCenter:ZJASKUDataCenter = ZJASKUDataCenter.sharedInstance
        return dataCenter.skuItemArray
    }()
    
//    lazy var addPhotoHeaderView:UIView = {
//        let titleView = UIView()
//        titleView.backgroundColor = UIColor.white
//        let titleLabel = UILabel()
//        titleLabel.text = "照片"
//        titleLabel.textColor = COLOR_TEXT_LABEL
//        titleLabel.font = UIFont.systemFont(ofSize: 15)
//        titleLabel.textAlignment = .left
//        titleView.addSubview(titleLabel)
//        
//        let editButton = UIButton(type: UIButtonType.custom)
//        editButton.backgroundColor = UIColor.gray
//        editButton.setTitle("编辑", for: .normal)
//        editButton.setTitleColor(UIColor.colorWithHexString(hex: "e6454a"), for: .normal)
//        titleView.addSubview(editButton)
//        
//        titleLabel.snp.makeConstraints({ (make) in
//            make.left.equalTo(15)
//            make.right.equalTo(editButton.snp.left).offset(0)
//            make.top.bottom.equalTo(0)
//        })
//        editButton.snp.makeConstraints({ (make) in
//            make.right.equalTo(0)
//            make.width.equalTo(50)
//            make.height.equalTo(50)
//            make.top.equalTo(0)
//        })
//        return titleView
//    }()
    
    lazy var tagListHeaderView:SYTagListView = {
        let tagView:SYTagListView = SYTagListView(frame: self.tagListFrame, andTags: [], isCanEdit: true)
        tagView.backgroundColor = UIColor.white
        tagView.addSubview(self.tagTitleView)
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
        
        let lineView = UIView()
        lineView.backgroundColor = COLOR_TABLE_LINE
        tagView.addSubview(lineView)
        
        self.tagTitleView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(0)
            make.size.equalTo(CGSize(width:40, height:40))
        }
        
        lineView.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        })

        tagView.addSKUTag({ [weak self](tagNameList) in
            self?.reloadData()
            self?.currentSKUItemModel?.tagList = tagNameList
        })
        
        tagView.didUpdatedTagListViewFrame({ [weak self](frame) in
            self?.tagListFrame = frame
        })
        
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

extension ZJASKUAddTableView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ZJASKUAddPhotoHeaderViewIdentifier)
            (headerView as! ZJASKUAddPhotoHeaderView).editButton.addTarget(self, action: #selector(didTappedEditButton(sender:)), for: .touchUpInside)
            return headerView
            
        case 1:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                ZJASKUTypeViewCellIdentifier)
            return headerView
        case 2:
            return tagListHeaderView
        default:
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let footerView = UIView()
            footerView.backgroundColor = UIColor.white
            let lineView = UIView()
            lineView.backgroundColor = COLOR_TABLE_LINE
            footerView.addSubview(lineView)
            
            lineView.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.bottom.right.equalTo(0)
                make.height.equalTo(0.5)
            })
            
            return footerView
        case 1:
            let footerView = UIView()
            let topLineView = UIView()
            topLineView.backgroundColor = COLOR_BORDER_LINE
            let bottomLineView = UIView()
            bottomLineView.backgroundColor = COLOR_TABLE_LINE
            footerView.addSubview(topLineView)
            footerView.addSubview(bottomLineView)
            
            topLineView.snp.makeConstraints({ (make) in
                make.left.right.top.equalTo(0)
                make.height.equalTo(0.5)
            })
            
            bottomLineView.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(0.5)
            })
            
            return footerView
        default:
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 40
        case 1:
            return 40
        case 2:
            return tagListFrame.size.height
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 15
        case 1:
            return 15
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let cell:ZJASKUAddCell = tableView.dequeueReusableCell(withIdentifier: ZJASKUAddCellIdentifier) as! ZJASKUAddCell
            let itemHeight = cell.getCollectionItemHeight()
            if skuItemArray.count > 2 {
                return itemHeight*2+15
            } else {
                return itemHeight
            }
        case 1:
            if isClickTypeArrowButton == true {
                let cell:ZJASKUTypeViewCell = tableView.dequeueReusableCell(withIdentifier: ZJASKUTypeViewCellIdentifier) as! ZJASKUTypeViewCell
                return cell.getItemHeight()+15
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        var cell:UITableViewCell?;
        switch indexPath.section {
        case 0:
            (cell as! ZJASKUAddCell).configCell()
        case 1: break
        case 2: break
//            (cell as! ZJASKUTagViewCell).configTagCell(tagList: currentSKUItemModel?.tagList)
//            (cell as! ZJASKUTagViewCell).tagView.tagsArr = currentSKUItemModel?.tagList
        default: break
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        switch section {
        case 0:
            if ZJASKUDataCenter.sharedInstance.isEditState == true {
                (view as! ZJASKUAddPhotoHeaderView).editButton.setTitle("完成", for: .normal)
            } else {
                (view as! ZJASKUAddPhotoHeaderView).editButton.setTitle("删除", for: .normal)
            }
        case 1:
            let headerView = view as! ZJASKUTypeHeaderView
            if isAddTarget == false {
                headerView.arrowButton.addTarget(self, action: #selector(didTappendArrowButton(sender:)), for: .touchUpInside)
                let panGester = UITapGestureRecognizer(target: self, action: #selector(didTappendArrowButton(sender:)))
                headerView.addGestureRecognizer(panGester)
                isAddTarget = true
            }
            headerView.configHeaderView(isClickArrowButton: isClickTypeArrowButton)
        default: break
        }
    }

}

extension ZJASKUAddTableView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 0
        }
        return 1
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?;
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: ZJASKUAddCellIdentifier)
            (cell as! ZJASKUAddCell).clickIndexBlock = {[weak self] (itemModel:ZJASKUItemModel) in
                self?.currentSKUItemModel = itemModel
                self?.tagListHeaderView.reset(withTags: itemModel.tagList)
            }
            (cell as! ZJASKUAddCell).clickAddButtonblock = {[weak self] in
                self?.skuDelegate?.didTappedAddPhotoButton()
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: ZJASKUTypeViewCellIdentifier)
//        case 2:
//            cell = tableView.dequeueReusableCell(withIdentifier: ZJASKUTagCellIdentifier)
//            cell?.selectionStyle = .none;
//            (cell as! ZJASKUTagViewCell).updateTagListBlock = {[weak self] (tagNameList:Array<Any>) in
//                self?.currentSKUItemModel?.tagList = tagNameList
//                self?.reloadRows(at: [indexPath], with: .none)
//            }
        default:
            let cellIdentifier = "ZJASKUNormalCell"
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        return cell!
    }
}

// MARK: - Event and Respones
extension ZJASKUAddTableView {
    
    @objc func didTappendArrowButton(sender:UIButton) {
        isClickTypeArrowButton = !isClickTypeArrowButton
        reloadData()
    }
    
    @objc func didTappedEditButton(sender: UIButton) {
        let skuInstance = ZJASKUDataCenter.sharedInstance
        if skuInstance.isEditState == true {
            skuInstance.isEditState = false
        } else {
            skuInstance.isEditState = true
        }
        let index = NSIndexSet(index: 0)
        reloadSections(index as IndexSet, with: .none)
    }
    
}
