//
//  ZJASKUAddCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/11/29.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUAddCell: UITableViewCell {
    
    typealias ClickPhotoIndexCallback = (ZJASKUItemModel) -> ()
    typealias ClickAddButtonCallback = () -> ()
    
    let addPhotoCellIdentifier = "ZJASKUAddPhotoCellIdentifier"
    let addButtonCellIdentifier = "ZJASKUAddButtonCellIdentifier"
    var itemWidth:CGFloat = 0
    var cellIndexPath:IndexPath?
    var selPhotoCell:ZJASKUAddPhotoCell?
    var clickIndexBlock:ClickPhotoIndexCallback?
    var clickAddButtonblock:ClickAddButtonCallback?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareUI()
        setUpViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func getCollectionItemHeight() -> CGFloat {
        return itemWidth
    }
    
    public func configCell() {
        self.addPhotoCollectionView.reloadData()
    }
    
    private func prepareUI() {
        contentView.addSubview(addPhotoCollectionView)
    }
    
    private func setUpViewConstraints() {
        addPhotoCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    public lazy var addPhotoCollectionView:UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        let specing:CGFloat = 15
        collectionLayout.minimumInteritemSpacing = specing
        collectionLayout.minimumLineSpacing = specing
        collectionLayout.sectionInset = UIEdgeInsetsMake(0, specing, 0, specing)
        collectionLayout.scrollDirection = .vertical
        self.itemWidth = (SCREEN_WIDTH - specing*CGFloat(4))/CGFloat(3)
        collectionLayout.itemSize = CGSize(width: self.itemWidth, height: self.itemWidth)
        
        let collectionView:UICollectionView = UICollectionView(frame: self.frame, collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ZJASKUAddPhotoCell.self, forCellWithReuseIdentifier: self.addPhotoCellIdentifier)
        collectionView.register(ZJASKUAddButtonCell.self, forCellWithReuseIdentifier: self.addButtonCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    lazy var dataCenter:ZJASKUDataCenter = {
        return ZJASKUDataCenter.sharedInstance
    }()

}

extension ZJASKUAddCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCenter.skuItemArray.count+1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let skuInstance:ZJASKUDataCenter! = ZJASKUDataCenter.sharedInstance
        if indexPath.row == dataCenter.skuItemArray.count {
            let addButtonCell:ZJASKUAddButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: addButtonCellIdentifier, for: indexPath) as! ZJASKUAddButtonCell
            return addButtonCell
        }
        let addPhotoCell:ZJASKUAddPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: addPhotoCellIdentifier, for: indexPath) as! ZJASKUAddPhotoCell
        addPhotoCell.photoImageView.addTarget(self, action: #selector(didTapCollectionView(sender:)), for: .touchUpInside)
        addPhotoCell.deleteButton.addTarget(self, action: #selector(didTappedPhotoDeleteBtn(sender:)), for: .touchUpInside)
        let itemModel:ZJASKUItemModel = dataCenter.skuItemArray.object(at: indexPath.row) as! ZJASKUItemModel
        let photoImage:UIImage = itemModel.photoImage!
        addPhotoCell.configCell(image: photoImage, isEdit: skuInstance.isEditState)
        
        if skuInstance.selCellIndexPath == nil {
            cellIndexPath = indexPath
            skuInstance.selCellIndexPath = indexPath
        } else {
            cellIndexPath = skuInstance.selCellIndexPath
        }
        
        return addPhotoCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row < dataCenter.skuItemArray.count {
            if indexPath.row == cellIndexPath?.row {
                (cell as! ZJASKUAddPhotoCell).photoImageView.layer.borderWidth = 1
                (cell as! ZJASKUAddPhotoCell).photoImageView.layer.borderColor = COLOR_MAIN_APP.cgColor
            } else {
                (cell as! ZJASKUAddPhotoCell).photoImageView.layer.borderWidth = 0
            }
        }
    }
    
    @objc public func didTapCollectionView(sender:UIButton) {
        let cell:ZJASKUAddPhotoCell = sender.superview?.superview as! ZJASKUAddPhotoCell
        selPhotoCell?.photoImageView.layer.borderWidth = 0
        cellIndexPath = self.addPhotoCollectionView.indexPath(for: cell)
        let itemModel = ZJASKUDataCenter.sharedInstance.getSKUItemModel(index: (cellIndexPath?.row)!)
        self.clickIndexBlock?(itemModel)
        addPhotoCollectionView.reloadData()
        selPhotoCell = cell
        ZJASKUDataCenter.sharedInstance.selCellIndexPath = cellIndexPath
    }
    
    @objc public func didTappedPhotoDeleteBtn(sender: UIButton) {
        let cell:ZJASKUAddPhotoCell = sender.superview?.superview?.superview as! ZJASKUAddPhotoCell
        cellIndexPath = self.addPhotoCollectionView.indexPath(for: cell)
        ZJASKUDataCenter.sharedInstance.removeSKUItem(index: (cellIndexPath?.row)!)
        addPhotoCollectionView.reloadData()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.clickAddButtonblock?()
    }
    
}
