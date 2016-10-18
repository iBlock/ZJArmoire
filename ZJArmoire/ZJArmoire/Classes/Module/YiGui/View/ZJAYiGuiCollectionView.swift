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
        let specing:CGFloat = 15
        layout.minimumInteritemSpacing = specing
        layout.minimumLineSpacing = specing
        layout.sectionInset = UIEdgeInsetsMake(specing, specing, specing, specing)
        layout.scrollDirection = .vertical
        let itemWidth = (frame.width - specing*CGFloat(3))/CGFloat(2)
        layout.itemSize = CGSize(width: itemWidth, height: SCREEN_WIDTH * 0.5)
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


