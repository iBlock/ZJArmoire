//
//  ZJADapeiListCollectionView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/26.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJADapeiListCollectionView: UICollectionView {

    let categoryIdentifier = "DapeiListCellItem"
    var dapeiModel: [ZJADapeiModel]! = [ZJADapeiModel]()
    
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
        register(ZJADapeiListCell.self, forCellWithReuseIdentifier: categoryIdentifier)
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

extension ZJADapeiListCollectionView: UICollectionViewDelegate,UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionView:ZJADapeiListCell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath) as! ZJADapeiListCell
        return collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let collectionView:ZJADapeiListCell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath) as! ZJADapeiListCell
        let dpModel: ZJADapeiModel = self.dapeiModel[indexPath.row]
        let clothesModels = dpModel.clothesList
        collectionView.configCell(photoList: clothesModels!)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dapeiModel.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath)
    }
    
}
