//
//  ZJAAddDapeiCollectionView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/22.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation

class ZJAAddDapeiCollectionView: UICollectionView {
    
    var selectedPhotos: Array<UIImage>!
    var selectedAssets: Array<Any>!
    var itemWH: CGFloat = 0
    let margin: CGFloat = 4
    let photoCellIdentifier = "ZJAPhotoCellIdentifier"
    
    init(frame: CGRect) {
        let layout = LxGridViewFlowLayout()
        itemWH = (SCREEN_WIDTH - 2 * margin - 4) / 3 - margin;
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = COLOR_MAIN_BACKGROUND
        alwaysBounceVertical = true
        contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        dataSource = self
        delegate = self
        keyboardDismissMode = .onDrag
        register(ZJAPreviewPhotoCell.self, forCellWithReuseIdentifier: photoCellIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZJAAddDapeiCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedPhotos.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ZJAPreviewPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! ZJAPreviewPhotoCell
        cell.videoImageView.isHidden = true
        if indexPath.row == self.selectedPhotos.count {
            cell.imageView.image = UIImage(named: "AlbumAddBtn.png")
            cell.deleteBtn.isHidden = true
            cell.gifLable.isHidden = true
        } else {
            cell.imageView.image = selectedPhotos[indexPath.row];
            cell.asset = selectedAssets[indexPath.row];
            cell.deleteBtn.isHidden = false
        }
        cell.gifLable.isHidden = true
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnClick(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ZJAAddDapeiCollectionView {
    func deleteBtnClick(sender: UIButton) {
        selectedPhotos.remove(at: sender.tag)
        selectedAssets.remove(at: sender.tag)
        self.performBatchUpdates({ 
            let indexPath = NSIndexPath(item: sender.tag, section: 0)
            self.deleteItems(at: [indexPath as IndexPath])
        }) { (finish: Bool) in
            self.reloadData()
        }
    }
}
