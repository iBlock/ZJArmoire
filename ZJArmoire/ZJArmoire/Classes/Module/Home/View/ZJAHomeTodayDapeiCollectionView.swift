//
//  ZJAHomeTodayDapeiCollectionView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/4.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJAHomeTodayDapeiCollectionView: UICollectionView {

    let layout = UICollectionViewFlowLayout()
    
    init(frame: CGRect) {
        let specing:CGFloat = 5
        layout.minimumInteritemSpacing = specing
        layout.minimumLineSpacing = specing
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15)
        layout.scrollDirection = .vertical
        let itemWidth = (SCREEN_WIDTH - specing*2-30)/3-1
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.1)
        super.init(frame: frame, collectionViewLayout: layout)
        
        prepareUI()
        setupviewConstraints()
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return layout.collectionViewContentSize.height
    }
    
    func prepareUI() {
        backgroundColor = UIColor.white
        isScrollEnabled = false
    }
    
    func setupviewConstraints() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
