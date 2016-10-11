//
//  JZAHomeCollectionView.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/5.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class JZAHomeCollectionView: UICollectionView {

    init(frame: CGRect) {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        super.init(frame: frame, collectionViewLayout: collectionFlowLayout)
        
        backgroundColor = UIColor.gray
//        delegate = self;
//        dataSource = self;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
