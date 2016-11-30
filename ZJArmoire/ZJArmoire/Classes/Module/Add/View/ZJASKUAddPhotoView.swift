//
//  ZJASKUAddPhotoView.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/11/29.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUAddPhotoView: UIView {
    
    let addPhotoCellIdentifier = "ZJASKUAddPhotoCellIdentifier"
    var itemWidth:CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
        setUpViewConstriants()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getCollectionItemHeight() -> CGFloat {
        return itemWidth
    }
    
    private func prepareUI() {
        addSubview(addPhotoCollectionView)
    }
    
    private func setUpViewConstriants() {
        addPhotoCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    private lazy var addPhotoCollectionView:UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        let specing:CGFloat = 15
        collectionLayout.minimumInteritemSpacing = specing
        collectionLayout.minimumLineSpacing = specing
        collectionLayout.sectionInset = UIEdgeInsetsMake(0, specing, 0, specing)
        collectionLayout.scrollDirection = .vertical
        self.itemWidth = (SCREEN_WIDTH - specing*CGFloat(4))/CGFloat(3)
        collectionLayout.itemSize = CGSize(width: self.itemWidth, height: self.itemWidth)
        
        let collectionView:UICollectionView = UICollectionView(frame: self.frame, collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ZJASKUAddPhotoCell.self, forCellWithReuseIdentifier: self.addPhotoCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    lazy var dataCenter:ZJASKUDataCenter = {
        return ZJASKUDataCenter.sharedInstance
    }()

}

extension ZJASKUAddPhotoView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCenter.skuItemArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let addPhotoCell:ZJASKUAddPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: addPhotoCellIdentifier, for: indexPath) as! ZJASKUAddPhotoCell
        let itemModel:ZJASKUItemModel = dataCenter.skuItemArray.object(at: indexPath.row) as! ZJASKUItemModel
        let photoImage:UIImage = itemModel.photoImage!
        addPhotoCell.configCell(image: photoImage)
        return addPhotoCell
    }
    
}
