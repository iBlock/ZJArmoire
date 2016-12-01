//
//  ZJASKUAddTableView.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/11/29.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUAddTableView: UITableView {
    
    let ZJASKUAddCellIdentifier = "ZJASKUAddCellIdentifier"
    let ZJASKUTypeViewCellIdentifier = "ZJASKUTypeViewCellIdentifier"
    let ZJASKUAddPhotoHeaderViewIdentifier = "ZJASKUAddPhotoHeaderViewIdentifier"
    let ZJASKUTypeHeaderViewIdentifier = "ZJASKUTypeHeaderViewIdentifier"
    
    var isClickTypeArrowButton:Bool = false
    static var isAddTarget:Bool = false

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        prepareUI()
        setUpViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareUI() -> Void {
        backgroundColor = COLOR_MAIN_BACKGROUND
        delegate = self
        dataSource = self
        separatorStyle = .none
        register(ZJASKUAddCell.self, forCellReuseIdentifier: ZJASKUAddCellIdentifier)
        register(ZJASKUTypeViewCell.self, forCellReuseIdentifier: ZJASKUTypeViewCellIdentifier)
        register(ZJASKUAddPhotoHeaderView.self, forHeaderFooterViewReuseIdentifier: ZJASKUAddPhotoHeaderViewIdentifier)
        register(ZJASKUTypeHeaderView.self, forHeaderFooterViewReuseIdentifier: ZJASKUTypeViewCellIdentifier)
    }
    
    func setUpViewConstraints() -> Void {
        
    }
    
    lazy var skuItemArray:NSArray = {
        let dataCenter:ZJASKUDataCenter = ZJASKUDataCenter.sharedInstance
        return dataCenter.skuItemArray
    }()
    
    lazy var addPhotoHeaderView:UIView = {
        let titleView = UIView()
        titleView.backgroundColor = UIColor.white
        let titleLabel = UILabel()
        titleLabel.text = "照片"
        titleLabel.textColor = COLOR_TEXT_LABEL
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .left
        titleView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.right.bottom.equalTo(0)
        })
        return titleView
    }()
}

extension ZJASKUAddTableView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ZJASKUAddPhotoHeaderViewIdentifier)
            return headerView
            
        case 1:
            let headerView:ZJASKUTypeHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                ZJASKUTypeViewCellIdentifier) as! ZJASKUTypeHeaderView
            if ZJASKUAddTableView.isAddTarget == false {
                 headerView.arrowButton.addTarget(self, action: #selector(didTappendArrowButton(sender:)), for: .touchUpInside)
                let panGester = UITapGestureRecognizer(target: self, action: #selector(didTappendArrowButton(sender:)))
                headerView.addGestureRecognizer(panGester)
                ZJASKUAddTableView.isAddTarget = true
            }
            headerView.configHeaderView(isClickArrowButton: isClickTypeArrowButton)
            
            return headerView
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
            lineView.backgroundColor = UIColor.colorWithHexString(hex: "d9d9d9")
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
            bottomLineView.backgroundColor = COLOR_BORDER_LINE
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
        switch indexPath.section{
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
            return 100
        }
    }
}

extension ZJASKUAddTableView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: ZJASKUTypeViewCellIdentifier)
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
    
}
