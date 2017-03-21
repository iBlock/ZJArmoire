//
//  ZJATuiJianDapeiCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/4.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJATuiJianDapeiCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareUI() {
        contentView.addSubview(tuiJianCollectionView)
    }
    
    func setupViewConstraints() {
        tuiJianCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func configCell(todayModel: ZJADapeiModel, dapeiModels: [ZJADapeiModel]) {
        tuiJianCollectionView.dapeiModels = dapeiModels
        tuiJianCollectionView.todayModel = todayModel
        tuiJianCollectionView.reloadData()
    }
    
    public func getCellHeight() -> CGFloat {
        return tuiJianCollectionView.getCollectionViewHeight()-20
    }
    
    private lazy var tuiJianCollectionView: ZJADapeiListCollectionView = {
        let frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0)
        let collectionView: ZJADapeiListCollectionView = ZJADapeiListCollectionView(frame: frame, collectionViewLayout: self.collectionLayout)
        collectionView.isSelecter = true
        collectionView.backgroundColor = UIColor.white
        collectionView.isUserInteractionEnabled = false
        return collectionView
    }()

    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let specing:CGFloat = 5
        layout.minimumInteritemSpacing = specing
        layout.minimumLineSpacing = specing
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15)
        layout.scrollDirection = .vertical
        let itemWidth = (SCREEN_WIDTH - specing*CGFloat(3)-30)/CGFloat(2)
        layout.itemSize = CGSize(width: itemWidth, height: SCREEN_WIDTH * 0.5)
        return layout
    }()
}
