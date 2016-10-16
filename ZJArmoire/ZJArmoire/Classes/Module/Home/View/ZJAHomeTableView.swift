//
//  ZJAHomeTableView.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/16.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJAHomeTableView: UITableView {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ZJAHomeTableView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ZJAHomeCellIdentifier"
        var homeCell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if (homeCell == nil) {
            homeCell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        return homeCell
    }
}

extension ZJAHomeTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 174
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ZJAHomeTableHeaderView(frame: self.bounds)
        return headerView
    }
}
