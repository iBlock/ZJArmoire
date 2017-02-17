//
//  ZJATypeListCollectionView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/1/16.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation

class ZJATypeListCollectionView: UICollectionView {
    
    let categoryIdentifier = "YiGuiTypeCellItem"
    var clothesModelList: Array<ZJAClothesModel> = []
    
    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        let specing:CGFloat = 15
        layout.minimumInteritemSpacing = specing
        layout.minimumLineSpacing = specing
        layout.sectionInset = UIEdgeInsetsMake(specing, specing, specing, specing)
        layout.scrollDirection = .vertical
        let itemWidth = (frame.width - specing*CGFloat(3))/CGFloat(2)
        layout.itemSize = CGSize(width: itemWidth, height: SCREEN_WIDTH * 0.5)
        super.init(frame: frame, collectionViewLayout: layout)
        
        prepareUI()
        register(ZJATypelistCollectionCell.self, forCellWithReuseIdentifier: categoryIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        backgroundColor = COLOR_MAIN_BACKGROUND
        delegate = self
        dataSource = self
    }
}

extension ZJATypeListCollectionView: UICollectionViewDelegate,UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionView:ZJATypelistCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath) as! ZJATypelistCollectionCell
        collectionView.configCell(image: clothesModelList[indexPath.row].clothesImg)
        return collectionView
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clothesModelList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath)
        let editVC = ZJAEditSkuController()
        let model: ZJAClothesModel = clothesModelList[indexPath.row]
        editVC.clothesModel = model
        ZJATabBarController.sharedInstance.navigationController?.pushViewController(editVC, animated: true)
    }
    
}

