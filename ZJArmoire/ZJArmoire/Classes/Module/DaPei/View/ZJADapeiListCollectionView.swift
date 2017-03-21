//
//  ZJADapeiListCollectionView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/26.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJADapeiListCollectionView: UICollectionView {

    typealias ClickDapeiCallback = (_ dapeiModel: ZJADapeiModel) -> Void
    let categoryIdentifier = "DapeiListCellItem"
    var layout = UICollectionViewFlowLayout()
    var dapeiModels: [ZJADapeiModel]! = [ZJADapeiModel]()
    var todayModel: ZJADapeiModel?
    var clickblock: ClickDapeiCallback?
    var isSelecter: Bool = false
    
    init(frame: CGRect) {
        let specing:CGFloat = 10
        layout.minimumInteritemSpacing = specing
        layout.minimumLineSpacing = specing
        layout.sectionInset = UIEdgeInsetsMake(specing, specing, specing, specing)
        layout.scrollDirection = .vertical
        let itemWidth = (frame.width - specing*CGFloat(3))/CGFloat(2)
        layout.itemSize = CGSize(width: itemWidth, height: SCREEN_WIDTH * 0.5)
        super.init(frame: frame, collectionViewLayout: layout)
        prepareUI()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.layout = layout as! UICollectionViewFlowLayout
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getCollectionViewHeight() -> CGFloat {
        return layout.collectionViewContentSize.height+10*CGFloat(2)
    }
    
    private func prepareUI() {
        register(ZJADapeiListCell.self, forCellWithReuseIdentifier: categoryIdentifier)
        backgroundColor = UIColor.white
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
        let collectionView:ZJADapeiListCell = cell as! ZJADapeiListCell
        let dpModel: ZJADapeiModel = self.dapeiModels[indexPath.row]
        var isSelector = false
        if let dpId = todayModel?.dapei_id {
            isSelector = dpModel.dapei_id == dpId
        }
        collectionView.configCell(dpModel: dpModel, isSelector: isSelector)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dapeiModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath)
        clickblock?(dapeiModels[indexPath.row])
    }
    
}
