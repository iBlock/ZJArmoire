//
//  ZJAHomeTuiJianCell.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/16.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJAHomeTuiJianCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func prepareUI() {
        backgroundColor = UIColor.white
        contentView.addSubview(tuiJianView)
    }
    
    private func setUpViewConstraints() {
        tuiJianView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var tuiJianView:UIView = {
        let tuijianView = UIView()
        
        let upLine = UIView()
        upLine.backgroundColor = COLOR_BORDER_LINE
        tuijianView.addSubview(upLine)
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = COLOR_BORDER_LINE
        tuijianView.addSubview(bottomLine)
        
        return tuijianView
    }()

}
