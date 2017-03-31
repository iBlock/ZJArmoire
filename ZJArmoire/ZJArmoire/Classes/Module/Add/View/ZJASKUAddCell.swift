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
    typealias SelectedPhotoCallback = ([UIImage]!) -> ()
    typealias DeletePhotoCallback = () -> Void
    
    let addPhotoCellIdentifier = "ZJASKUAddPhotoCellIdentifier"
    let addButtonCellIdentifier = "ZJASKUAddButtonCellIdentifier"
    let collectionLayout = UICollectionViewFlowLayout()
    var itemWidth:CGFloat = 0
    var cellIndexPath:IndexPath?
    var selPhotoCell:ZJASKUAddPhotoCell?
    var clickIndexBlock:ClickPhotoIndexCallback?
    var selectedPhotoBlock: SelectedPhotoCallback?
    var deletePhotoBlock: DeletePhotoCallback?
//    var clickAddButtonblock:ClickAddButtonCallback?
    
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
        let height = collectionLayout.collectionViewContentSize.height
        return height
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
        let specing:CGFloat = 15
        self.collectionLayout.minimumInteritemSpacing = specing
        self.collectionLayout.minimumLineSpacing = specing
        self.collectionLayout.sectionInset = UIEdgeInsetsMake(0, specing, 0, specing)
        self.collectionLayout.scrollDirection = .vertical
        self.itemWidth = (SCREEN_WIDTH - specing*CGFloat(4))/CGFloat(3)
        self.collectionLayout.itemSize = CGSize(width: self.itemWidth, height: self.itemWidth)
        let frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0)
        let collectionView:UICollectionView = UICollectionView(frame: frame, collectionViewLayout: self.collectionLayout)
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
        
        if cell .isKind(of: ZJASKUAddPhotoCell.self) {
            let viewCell: ZJASKUAddPhotoCell = cell as! ZJASKUAddPhotoCell
            let itemModel:ZJASKUItemModel = dataCenter.skuItemArray.object(at: indexPath.row) as! ZJASKUItemModel
//            let skuInstance:ZJASKUDataCenter! = ZJASKUDataCenter.sharedInstance
            var photoImage:UIImage
            
            if let img = itemModel.cellImg {
                photoImage = img
            } else {
                photoImage = itemModel.photoImage!.autoResizeImage(newSize: viewCell.size)
                itemModel.cellImg = photoImage
            }
            
            viewCell.configCell(image: photoImage, isEdit: true)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        didTappedAddPhotoButton()
    }
    
}

extension ZJASKUAddCell {
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
    
    // 点击删除图片按钮
    @objc public func didTappedPhotoDeleteBtn(sender: UIButton) {
        let cell:ZJASKUAddPhotoCell = sender.superview?.superview?.superview as! ZJASKUAddPhotoCell
        cellIndexPath = self.addPhotoCollectionView.indexPath(for: cell)
        ZJASKUDataCenter.sharedInstance.removeSKUItem(index: (cellIndexPath?.row)!)
        addPhotoCollectionView.reloadData()
        deletePhotoBlock?()
    }
    
    // 点击添加图片按钮
    func didTappedAddPhotoButton() {
        let selectorView = ZJAPhotoSelectorView()
        selectorView.photoTypeClick = { [weak self](type: ZJAPhotoSelectorType) -> () in
            switch type {
            case .takeImage:
                let cameraController = ZJACameraController()
                cameraController.addPhotoBlock = {[weak self](image) in
                    self?.selectedPhotoBlock?([image])
                }
                let cameraNavi = UINavigationController(rootViewController: cameraController)
                let tabVc = ZJATabBarController.sharedInstance
                tabVc.navigationController?.present(cameraNavi, animated: true, completion: nil)
            case .selectorImage:
                self?.pushImagePickerController()
            }
        }
        selectorView.show()
    }
    
    // 弹出照片选择界面
    func pushImagePickerController() {
        let imagePickerVc: TZImagePickerController! = TZImagePickerController(maxImagesCount: 1, delegate: self)
        imagePickerVc.naviBgColor = COLOR_MAIN_APP
        imagePickerVc.allowTakePicture = false
        imagePickerVc.allowPickingVideo = false
        imagePickerVc.allowPickingImage = true
        imagePickerVc.allowPickingOriginalPhoto = false
        imagePickerVc.allowPickingGif = false
        imagePickerVc.sortAscendingByModificationDate = true
        imagePickerVc.allowCrop = false
        imagePickerVc.needCircleCrop = false
        let tabVc = ZJATabBarController.sharedInstance
        tabVc.navigationController?.present(imagePickerVc, animated: true, completion: nil)
    }
}

// 照片选择回调函数
extension ZJASKUAddCell: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
        let zoomController = RSKImageCropViewController(image: photos.first!, cropMode: .square)
        zoomController.delegate = self
        let tabVc = ZJATabBarController.sharedInstance
        tabVc.navigationController?.present(zoomController, animated: false, completion: nil)
    }
}

extension ZJASKUAddCell: RSKImageCropViewControllerDelegate {
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        let tabVc = ZJATabBarController.sharedInstance
        tabVc.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController,
                                 didCropImage croppedImage: UIImage,
                                 usingCropRect cropRect: CGRect) {
        selectedPhotoBlock?([croppedImage])
        let tabVc = ZJATabBarController.sharedInstance
        tabVc.navigationController?.dismiss(animated: true, completion: nil)
    }
}
