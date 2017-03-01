//
//  ZJADapeiCollectionView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/1.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJADapeiCollectionView: UICollectionView {

    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        let specing:CGFloat = 5
        layout.minimumInteritemSpacing = specing
        layout.minimumLineSpacing = specing
        layout.sectionInset = UIEdgeInsetsMake(specing, specing, specing, specing)
        layout.scrollDirection = .vertical
        layout.footerReferenceSize = CGSize(width: SCREEN_WIDTH, height: 50)
        let itemWidth = (frame.width - specing*CGFloat(4))/CGFloat(3)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth+15)
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
