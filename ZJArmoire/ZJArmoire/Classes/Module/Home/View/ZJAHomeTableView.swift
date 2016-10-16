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
        separatorStyle = .none
        backgroundColor = COLOR_MAIN_BACKGROUND
        let frame = CGRect(origin: frame.origin, size: CGSize(width:frame.width,height:174))
        tableHeaderView = ZJAHomeTableHeaderView(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ZJAHomeTableView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ZJAHomeTuiJianIdentifier"
        var tuiJianCell:ZJAHomeTuiJianCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ZJAHomeTuiJianCell!
        if (tuiJianCell == nil) {
            tuiJianCell = ZJAHomeTuiJianCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        return tuiJianCell
    }
}

extension ZJAHomeTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}
