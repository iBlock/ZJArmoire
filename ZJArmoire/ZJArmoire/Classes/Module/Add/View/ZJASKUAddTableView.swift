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
    var tagListFrame:CGRect! = CGRect(x:0,y:0,width:SCREEN_WIDTH,height:45)
    
    var currentSKUItemModel:ZJASKUItemModel?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        prepareUI()
        prepareOverriteData()
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
    
    lazy var tagListHeaderView:ZJATaglistHeaderView = {
        let tagView: ZJATaglistHeaderView = ZJATaglistHeaderView(frame: self.tagListFrame)
        tagView.addSKUTag({ [weak self](tagNameList) in
            DispatchQueue.main.async {
                self?.reloadData()
                self?.currentSKUItemModel?.tagList = tagNameList as? Array<String>
            }
        })
        tagView.didUpdatedTagListViewFrame({ [weak self](frame) in
            self?.tagListFrame = frame
        })
        return tagView
    }()
}

extension ZJASKUAddTableView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return self.customAddPhotoCellHeader(tableView: tableView)
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
            return self.customAddPhotoCellFooterView(tableView: tableView)
        case 1:
            let footerView = UIView()
            let topLineView = UIView()
            topLineView.backgroundColor = COLOR_BORDER_LINE
            footerView.addSubview(topLineView)
            topLineView.snp.makeConstraints({ (make) in
                make.left.right.top.equalTo(0)
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
            return self.fetchAddPhotoCellHeaderHeight()
        case 1:
            return 40
        case 2:
            return self.fetchTagListViewHeight()
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return self.fetchAddPhotoCellFooterHeight()
        case 1:
            return 15
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return self.fetchAddPhotoCellHeight(tableView: tableView)
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
        switch indexPath.section {
        case 0:
            self.configPhotoCell(cell: cell)
        case 1: break
        case 2: break
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
            if isCanEditSku() == false {
                headerView.arrowButton.isHidden = true
            } else {
                headerView.arrowButton.isHidden = false
            }
            headerView.arrowButton.addTarget(self, action: #selector(didTappendArrowButton(sender:)), for: .touchUpInside)
            let panGester = UITapGestureRecognizer(target: self, action: #selector(didTappendArrowButton(sender:)))
            headerView.addGestureRecognizer(panGester)
            headerView.configHeaderView(isClickArrowButton: isClickTypeArrowButton)
            if let category = currentSKUItemModel?.category {
                headerView.configCell(type: CONFIG_YIGUI_TYPENAMES[Int(category)])
            } else {
                headerView.configCell(type: CONFIG_YIGUI_TYPENAMES[0])
            }
        case 2:
            if isCanEditSku() == true {
                tagListHeaderView.isUserInteractionEnabled = true
            } else {
                tagListHeaderView.isUserInteractionEnabled = false
            }
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
            cell = self.customAddPhotoCell(tableView: tableView)
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: ZJASKUTypeViewCellIdentifier)
            (cell as! ZJASKUTypeViewCell).clickTypeBtnBlock =
            {[weak self](indexPath) in
                let indexSet = NSIndexSet(index: 1)
                self?.currentSKUItemModel?.category = indexPath.row
                self?.isClickTypeArrowButton = !(self?.isClickTypeArrowButton)!
                self?.reloadSections(indexSet as IndexSet, with: .automatic)
            }
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
        if self.isCanEditSku() == false {
            return
        }
        isClickTypeArrowButton = !isClickTypeArrowButton
        let index = NSIndexSet(index: 1)
        self.beginUpdates()
        self.reloadSections(index as IndexSet, with: .automatic)
        self.endUpdates()
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

// MARK: - Overrite Method
extension ZJASKUAddTableView {
    
    func prepareOverriteData() {
        
    }
    
    func configPhotoCell(cell: UITableViewCell) {
        (cell as! ZJASKUAddCell).configCell()
    }
    
    func fetchAddPhotoCellHeaderHeight() -> CGFloat {
        return 40
    }
    
    func fetchTagListViewHeight() -> CGFloat {
        return tagListFrame.size.height
    }
    
    func fetchAddPhotoCellHeight(tableView: UITableView) -> CGFloat {
        let cell:ZJASKUAddCell = tableView.dequeueReusableCell(withIdentifier: ZJASKUAddCellIdentifier) as! ZJASKUAddCell
        let itemHeight = cell.getCollectionItemHeight()
        if skuItemArray.count > 2 {
            return itemHeight*2+15
        } else {
            return itemHeight
        }
    }
    
    func fetchAddPhotoCellFooterHeight() -> CGFloat {
        return 15
    }
    
    func customAddPhotoCellHeader(tableView: UITableView) -> UIView {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ZJASKUAddPhotoHeaderViewIdentifier)
        (headerView as! ZJASKUAddPhotoHeaderView).editButton.addTarget(self, action: #selector(didTappedEditButton(sender:)), for: .touchUpInside)
        return headerView!
    }
    
    func customAddPhotoCellFooterView(tableView: UITableView) -> UIView {
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
    }
    
    func customAddPhotoCell(tableView: UITableView) -> UITableViewCell {
        let cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: ZJASKUAddCellIdentifier)
        (cell as! ZJASKUAddCell).clickIndexBlock = {[weak self] (itemModel:ZJASKUItemModel) in
            self?.currentSKUItemModel = itemModel
            self?.tagListHeaderView.reset(withTags: itemModel.tagList)
            let indexSet = NSIndexSet(index: 1)
            self?.reloadSections(indexSet as IndexSet, with: .automatic)
        }
        (cell as! ZJASKUAddCell).clickAddButtonblock = {[weak self] in
            self?.skuDelegate?.didTappedAddPhotoButton()
        }
        return cell!
    }
    
    func isCanEditSku() -> Bool {
        return true
    }
}
