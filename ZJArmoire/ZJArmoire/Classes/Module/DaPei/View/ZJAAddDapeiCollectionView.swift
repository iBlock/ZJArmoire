//
//  ZJAAddDapeiCollectionView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/22.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation

class ZJAAddDapeiCollectionView: UICollectionView {
    
    var layout: LxGridViewFlowLayout
    
    init(frame: CGRect) {
        layout = LxGridViewFlowLayout()
        layout.itemSize = CGSize(width: WH_PHOTOCOLLECTION_WIDTH, height: WH_PHOTOCOLLECTION_WIDTH)
        layout.minimumLineSpacing = WH_PHOTOCOLLECTION_LINESPEC
        layout.minimumInteritemSpacing = WH_PHOTOCOLLECTION_LINESPEC
        super.init(frame: frame, collectionViewLayout: layout)
        
        prepareUI()
        setupviewConstraints()
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return layout.collectionViewContentSize.height+WH_PHOTOCOLLECTION_LINESPEC*CGFloat(2)
    }
    
    func prepareUI() {
        backgroundColor = UIColor.white
        alwaysBounceVertical = true
        isScrollEnabled = false
        contentInset = UIEdgeInsets(top: WH_PHOTOCOLLECTION_LINESPEC, left: 15, bottom: WH_PHOTOCOLLECTION_LINESPEC, right: 15)
        keyboardDismissMode = .onDrag
    }
    
    func setupviewConstraints() {

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
