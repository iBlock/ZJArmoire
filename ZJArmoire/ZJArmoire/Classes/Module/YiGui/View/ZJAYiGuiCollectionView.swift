//
//  ZJAYiGuiCollectionView.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/10/17.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJAYiGuiCollectionView: UICollectionView {
    
    let categoryIdentifier = "YiguiCategoriesCellItem"
    
    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: SCREEN_WIDTH * 0.435, height: SCREEN_WIDTH * 0.5)
        super.init(frame: frame, collectionViewLayout: layout)
        
        prepareUI()
        register(ZJAYiGuiTypeCell.self, forCellWithReuseIdentifier: categoryIdentifier)
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

extension ZJAYiGuiCollectionView: UICollectionViewDelegate,UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionView:ZJAYiGuiTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath) as! ZJAYiGuiTypeCell
        return collectionView
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

}


