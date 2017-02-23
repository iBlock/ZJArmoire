//
//  ZJAAddDapeiCollectionView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/22.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation

class ZJAAddDapeiCollectionView: UICollectionView {
    
    var itemWH: CGFloat = 0
    var layout: LxGridViewFlowLayout
    let margin: CGFloat = 4
    
    init(frame: CGRect) {
        layout = LxGridViewFlowLayout()
        itemWH = (SCREEN_WIDTH - 2 * margin - 4) / 3 - margin;
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        super.init(frame: frame, collectionViewLayout: layout)
        
        prepareUI()
        setupviewConstraints()
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return layout.collectionViewContentSize.height
    }
    
    func prepareUI() {
        backgroundColor = UIColor.white
        alwaysBounceVertical = true
        isScrollEnabled = false
        contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        keyboardDismissMode = .onDrag
    }
    
    func setupviewConstraints() {

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.yellow
        titleLabel.text = "单品"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
}
