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
    let image1: UIImage? = UIImage(contentsOfFile: PATH_PHOTO_IMAGE+"1484587787335928433.png")
    var modelList: NSArray!
    weak var tableDelegate: ZJAHomeTableViewDelegate?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        separatorStyle = .none
        backgroundColor = COLOR_MAIN_BACKGROUND
        let frame = CGRect(origin: frame.origin, size: CGSize(width:frame.width,height:174))
        tableHeaderView = ZJAHomeTableHeaderView(frame: frame)
        register(ZJAHomeTuiJianCell.self, forCellReuseIdentifier: cellIdentifier)
        
        prepareCellModel()
        
        modelList =
            [["title":"个性搭配", "btn_title":"| 详情", "image_list":[image1,image1,image1]],
             ["title":"推荐搭配", "btn_title":"| 详情", "image_list":[image1,image1,image1]]]
    }
    
    func prepareCellModel() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current // 设置时区
        dateFormatter.dateFormat = "yyyyMMdd"
        let stringDate = dateFormatter.string(from: currentDate)
        let dapeiId = ZJATableDapei().fetchPrepareDapeiId(dapeiDate:stringDate)
        if dapeiId != nil {
            
        }
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
        let tuiJianCell:ZJAHomeTuiJianCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ZJAHomeTuiJianCell!
        tuiJianCell.detailButton.addTarget(self, action: #selector(didTappedDetailButton(sender:)), for: .touchUpInside)
        tuiJianCell.configCell(paras: modelList[indexPath.section] as! NSDictionary)
        return tuiJianCell
    }
    
    func didTappedDetailButton(sender: UIButton) {
        self.tableDelegate?.didTappedButton(sender: sender)
    }
}

extension ZJAHomeTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}





