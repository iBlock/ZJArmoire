//
//  ZJATodayDapeiCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/3.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJATodayDapeiCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(dapeiModel: [ZJADapeiModel]?) {
        if dapeiModel != nil {
            dapeiCollectionView.dapeiModel = dapeiModel
            dapeiCollectionView.reloadData()
        }
    }
    
    func getCellHeight() -> CGFloat {
        return dapeiCollectionView.getCollectionViewHeight()
    }
    
    private func prepareUI() {
        contentView.addSubview(dapeiCollectionView)
    }
    
    private lazy var dapeiCollectionView: ZJADapeiListCollectionView = {
        let collectionView: ZJADapeiListCollectionView = ZJADapeiListCollectionView(frame: self.contentView.bounds)
        collectionView.clickblock = { [weak self](dapeiModel: ZJADapeiModel) in
            
        }
        return collectionView
    }()

}
