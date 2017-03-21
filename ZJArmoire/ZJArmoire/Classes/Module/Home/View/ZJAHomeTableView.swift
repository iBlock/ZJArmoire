//
//  ZJAHomeTableView.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/16.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

protocol ZJAHomeTableViewDelegate: NSObjectProtocol {
//    func didTappedButton(sender: UIButton)
}

class ZJAHomeTableView: UITableView {
    
    let cellIdentifier: String = "ZJAHomeTableViewCell"
    let todayDapeiCellIdentifier: String = "todayDapeiCellIdentifier"
    let defaultCellIdentifer: String = "ZJAHomeTodayDefaultCell"
    var todayModel: ZJADapeiModel! = ZJADapeiModel()
    var tuiJianDapeiModels: [ZJADapeiModel] = [ZJADapeiModel]()
    var todayDapeiCellHeight: CGFloat = 0
    var tuijianDapeiCellHeight: CGFloat = 0
    var tableHeader: ZJAHomeTableHeaderView!
    
    weak var tableDelegate: ZJAHomeTableViewDelegate?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        separatorStyle = .none
        backgroundColor = UIColor.white
        estimatedRowHeight = 150
        let frame = CGRect(origin: frame.origin, size: CGSize(width:frame.width,height:160))
        tableHeader = ZJAHomeTableHeaderView(frame: frame)
        tableHeaderView = tableHeader
        register(ZJATuiJianDapeiCell.self, forCellReuseIdentifier: cellIdentifier)
        register(ZJADefaultTodayDapeiCell.self, forCellReuseIdentifier: defaultCellIdentifer)
        register(ZJATodayDapeiCell.self, forCellReuseIdentifier: todayDapeiCellIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didPushDapeiListPage() {
        let dapeiVc = ZJADaPeiController()
        dapeiVc.isSelecter = true
        let rootVc = ZJATabBarController.sharedInstance.navigationController
        rootVc?.pushViewController(dapeiVc, animated: true)
    }

}

extension ZJAHomeTableView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if tuiJianDapeiModels.count > 0 {
            return 2
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if todayModel.dapei_id == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellIdentifer)
                cell?.selectionStyle = .none
                return cell!
            } else {
                let cell: ZJATodayDapeiCell = tableView.dequeueReusableCell(withIdentifier: todayDapeiCellIdentifier) as! ZJATodayDapeiCell
                cell.selectionStyle = .none
                cell.configCell(dapeiModel: todayModel)
                todayDapeiCellHeight = cell.getCellHeight()
                return cell
            }
        } else if indexPath.section == 1 {
            if tuiJianDapeiModels.count > 0 {
                let tuiJianCell:ZJATuiJianDapeiCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ZJATuiJianDapeiCell!
                tuiJianCell.selectionStyle = .none
                tuiJianCell.configCell(todayModel: todayModel, dapeiModels: tuiJianDapeiModels)
                tuijianDapeiCellHeight = tuiJianCell.getCellHeight()
                return tuiJianCell
            }
        }
        return UITableViewCell()
    }
}

extension ZJAHomeTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
//        headerView.backgroundColor = UIColor.colorWithHexString(hex: "f5fafb")
        headerView.backgroundColor = UIColor.white
        let titleLabel = UILabel()
        if section == 0 {
            titleLabel.text = "今日搭配"
        } else if section == 1 {
            titleLabel.text = "推荐搭配"
        }
        titleLabel.textColor = UIColor.colorWithHexString(hex: "213550")
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        headerView.addSubview(titleLabel)
        
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("选择 >", for: .normal)
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.colorWithHexString(hex: "213550"), for: .normal)
        headerView.addSubview(button)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didPushDapeiListPage))
        headerView.addGestureRecognizer(gesture)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalTo(0)
        }
        
        button.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.bottom.equalTo(0)
        }
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if todayModel.dapei_id != nil {
                return todayDapeiCellHeight
            }
        } else if indexPath.section == 1 {
            if tuiJianDapeiModels.count > 0 {
                return tuijianDapeiCellHeight
            }
        }
        
        return 150
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didPushDapeiListPage()
    }
}
