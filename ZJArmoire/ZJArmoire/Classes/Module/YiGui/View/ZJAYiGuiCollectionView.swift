//
//  ZJAYiGuiCollectionView.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/10/17.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

protocol ZJAYiGuiTypeCellDelegate:NSObjectProtocol {
    func typeCellClickCallback(index:IndexPath)
}

class ZJAYiGuiCollectionView: UICollectionView {
    
    let categoryIdentifier = "YiguiCategoriesCellItem"
    var typeCountList:NSDictionary?
    weak var cellDelegate:ZJAYiGuiTypeCellDelegate?
    
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
    
    lazy var typeImageList: NSArray = {
        return CONFIG_YIGUI_TYPEIMAGES as NSArray
    }()

    lazy var typeNameList: NSArray = {
        return CONFIG_YIGUI_TYPENAMES as NSArray
    }()
}

extension ZJAYiGuiCollectionView: UICollectionViewDelegate,UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionView:ZJAYiGuiTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath) as! ZJAYiGuiTypeCell
        let imageName = typeImageList.object(at: indexPath.row) as! String
        let imageTitle = typeNameList.object(at: indexPath.row) as! String
        var typeCont: String = "0"
        if let count = typeCountList?.object(forKey: String(indexPath.row)) {
            typeCont = count as! String
        }
        collectionView.configCell(image:imageName, title:imageTitle, typeCount: typeCont)
        return collectionView
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath)
        cellDelegate?.typeCellClickCallback(index: indexPath)
    }

}


