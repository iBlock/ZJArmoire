//
//  ZJATodayDapeiCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/3.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJATodayDapeiCell: UITableViewCell {
    
    let CellIdentifier = "ZJATodayDapeiCellIdentifier"
    var dapeiModel: ZJADapeiModel = ZJADapeiModel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(dapeiModel: ZJADapeiModel) {
        self.dapeiModel = dapeiModel
        dapeiCollectionView.reloadData()
    }
    
    func setupViewConstraints() {
        dapeiCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func getCellHeight() -> CGFloat {
        return dapeiCollectionView.getCollectionViewHeight()
    }
    
    private func prepareUI() {
        contentView.addSubview(dapeiCollectionView)
    }
    
    private lazy var dapeiCollectionView: ZJAHomeTodayDapeiCollectionView = {
        let collectionView: ZJAHomeTodayDapeiCollectionView = ZJAHomeTodayDapeiCollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.isUserInteractionEnabled = false
        collectionView.register(ZJATypelistCollectionCell.self, forCellWithReuseIdentifier: self.CellIdentifier)
        return collectionView
    }()

}

extension ZJATodayDapeiCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dapeiModel.dapei_id != nil {
            return dapeiModel.clothesList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let typeCell: ZJATypelistCollectionCell = cell as! ZJATypelistCollectionCell
        let clothesModel: ZJAClothesModel = dapeiModel.clothesList[indexPath.row]
        typeCell.configCell(clothesModel: clothesModel, isDelete: false)
    }
}
