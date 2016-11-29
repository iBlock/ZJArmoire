//
//  ZJASKUAddTableView.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/11/29.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUAddTableView: UITableView {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        prepareUI()
        setUpViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareUI() -> Void {
        delegate = self
        dataSource = self
    }
    
    func setUpViewConstraints() -> Void {
        
    }

}

extension ZJASKUAddTableView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
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
        case 1:
            let titleView = UIView()
            titleView.backgroundColor = UIColor.white
            let titleLabel = UILabel()
            titleLabel.text = "分类    上装"
            titleLabel.textColor = COLOR_TEXT_LABEL
            titleLabel.font = UIFont.systemFont(ofSize: 15)
            titleLabel.textAlignment = .left
            titleView.addSubview(titleLabel)
            
            titleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.right.bottom.equalTo(0)
            })
            
            return titleView
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
            let cellIdentifier = "ZJASKUAddCell"
            cell = ZJASKUAddCell(style: .default, reuseIdentifier: cellIdentifier)
            cell?.backgroundColor = UIColor.yellow
        default:
            let cellIdentifier = "ZJASKUNormalCell"
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        return cell!
    }
}
