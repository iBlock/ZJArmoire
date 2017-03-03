//
//  ZJAHomeTableView.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/16.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

protocol ZJAHomeTableViewDelegate: NSObjectProtocol {
    func didTappedButton(sender: UIButton)
}

class ZJAHomeTableView: UITableView {
    
    let cellIdentifier: String = "ZJAHomeTableViewCell"
    let todayDapeiCellIdentifier: String = "todayDapeiCellIdentifier"
    let defaultCellIdentifer: String = "ZJAHomeTodayDefaultCell"
    var todayModel: ZJADapeiModel?
    var tuiJianDapeiModels: [ZJADapeiModel]?
    var todayDapeiCellHeight: CGFloat = 0
    
    weak var tableDelegate: ZJAHomeTableViewDelegate?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        separatorStyle = .none
        backgroundColor = UIColor.white
        let frame = CGRect(origin: frame.origin, size: CGSize(width:frame.width,height:174))
        tableHeaderView = ZJAHomeTableHeaderView(frame: frame)
        register(ZJAHomeTuiJianCell.self, forCellReuseIdentifier: cellIdentifier)
        register(ZJADefaultTodayDapeiCell.self, forCellReuseIdentifier: defaultCellIdentifer)
        register(ZJATodayDapeiCell.self, forCellReuseIdentifier: todayDapeiCellIdentifier)
//        prepareCellModel()
    }
    
//    func prepareCellModel() {
//        let currentDate = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale.current // 设置时区
//        dateFormatter.dateFormat = "yyyyMMdd"
//        let stringDate = dateFormatter.string(from: currentDate)
//        let dapeiId = ZJATableDapei().fetchPrepareDapeiId(dapeiDate:stringDate)
//        if dapeiId != nil {
//            
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ZJAHomeTableView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if todayModel == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellIdentifer)
                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: todayDapeiCellIdentifier)
                return cell!
            }
        } else if indexPath.section == 1 {
            let tuiJianCell:ZJAHomeTuiJianCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ZJAHomeTuiJianCell!
            tuiJianCell.detailButton.addTarget(self, action: #selector(didTappedDetailButton(sender:)), for: .touchUpInside)
            return tuiJianCell
        }
        return UITableViewCell()
    }
    
    func didTappedDetailButton(sender: UIButton) {
        self.tableDelegate?.didTappedButton(sender: sender)
    }
}

extension ZJAHomeTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if todayModel != nil {
                let cell: ZJATodayDapeiCell = cell as! ZJATodayDapeiCell
                todayDapeiCellHeight = cell.getCellHeight()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let titleLabel = UILabel()
        titleLabel.text = "今日搭配"
        titleLabel.textColor = COLOR_TEXT_LABEL
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalTo(0)
        }
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if todayModel != nil {
            return todayDapeiCellHeight
        }
        return 150
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dapeiVc = ZJADaPeiController()
        dapeiVc.isSelecter = true
        let rootVc = ZJATabBarController.sharedInstance.navigationController
        rootVc?.pushViewController(dapeiVc, animated: true)
    }
}





