//
//  ZJASelectedPhotoCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/23.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

protocol ZJASelectedPhotoCellProtocol: NSObjectProtocol {
    func selectedPhotoCallback(selectedPhotos: NSMutableArray,
                               selectedAssets: NSMutableArray,
                               photoCollectionViewHeight: CGFloat)
    func changePhotoLocationCallback(selectedPhotos: NSMutableArray,
                                     selectedAssets: NSMutableArray)
}

class ZJASelectedPhotoCell: UITableViewCell {
    var albumModels: [TZAlbumModel]!
    var selectedPhotos: NSMutableArray = NSMutableArray()
    var selectedAssets: NSMutableArray = NSMutableArray()
    var isSelectOriginalPhoto: Bool = false
    weak var delegate: ZJASelectedPhotoCellProtocol?
    let photoCellIdentifier = "ZJAPhotoCellIdentifier"
    let addPhotoCellIdentifier = "ZJAddPhotoCellIdentifier"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** 刷新图片CollectionView */
    func reloadPhotoCollection(photos: NSMutableArray,
                               assets: NSMutableArray) {
        selectedAssets = assets
        selectedPhotos = photos
        photoCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 1)) { 
            self.reloadPhotoCallback()
        }
        
    }
    
    func reloadPhotoCallback() {
        let height = photoCollectionView.getCollectionViewHeight()
        delegate?.selectedPhotoCallback(selectedPhotos: selectedPhotos, selectedAssets: selectedAssets, photoCollectionViewHeight: height)
    }
    
    func prepareUI() {
        contentView.addSubview(photoCollectionView)
        contentView.addSubview(bottomLine)
    }
    
    func setupViewConstraints() {
        photoCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
    }
    
    public lazy var photoCollectionView: ZJAAddDapeiCollectionView = {
        let collectionView = ZJAAddDapeiCollectionView(frame: CGRect.zero)
        collectionView.register(ZJAPreviewPhotoCell.self, forCellWithReuseIdentifier: self.photoCellIdentifier)
        collectionView.register(ZJASKUAddButtonCell.self, forCellWithReuseIdentifier: self.addPhotoCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = COLOR_TABLE_LINE
        return line
    }()

}

extension ZJASelectedPhotoCell: UICollectionViewDelegate, UICollectionViewDataSource, LxGridViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == selectedPhotos.count {
            pushImagePickerController()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedPhotos.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == self.selectedPhotos.count {
            let cell: ZJASKUAddButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: addPhotoCellIdentifier, for: indexPath) as! ZJASKUAddButtonCell
            return cell
        }
        
        let cell: ZJAPreviewPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! ZJAPreviewPhotoCell
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnClick(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.selectedPhotos.count  {
            return
        }
        let displayCell = cell as! ZJAPreviewPhotoCell
        displayCell.videoImageView.isHidden = true
        var photo = selectedPhotos[indexPath.row] as? UIImage
        photo = photo?.autoResizeImage(newSize: cell.size)
        displayCell.imageView.image = photo
        displayCell.asset = selectedAssets[indexPath.row];
        displayCell.deleteBtn.isHidden = false
        displayCell.gifLable.isHidden = true
        displayCell.deleteBtn.tag = indexPath.row
    }
    
    //MARK: - LxGridViewDataSource

    func collectionView(_ collectionView: UICollectionView!, canMoveLXItemAtIndex indexPath: IndexPath!) -> Bool {
        return indexPath.item < selectedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView!, itemAt sourceIndexPath: IndexPath!, canMoveTo destinationIndexPath: IndexPath!) -> Bool {
        return (sourceIndexPath.item < selectedPhotos.count && destinationIndexPath.item < selectedPhotos.count);
    }
    
    func collectionView(_ collectionView: UICollectionView!, itemAt sourceIndexPath: IndexPath!, didMoveTo destinationIndexPath: IndexPath!) {
        let image = selectedPhotos[sourceIndexPath.item]
        selectedPhotos.removeObject(at: sourceIndexPath.item)
        selectedPhotos.insert(image, at: destinationIndexPath.item)
        
        let asset = selectedAssets[sourceIndexPath.item]
        selectedAssets.removeObject(at: sourceIndexPath.item)
        selectedAssets.insert(asset, at: destinationIndexPath.item)
        
        collectionView.reloadData()
        delegate?.changePhotoLocationCallback(selectedPhotos: selectedPhotos,
                                              selectedAssets: selectedAssets)
    }
}

extension ZJASelectedPhotoCell {
    func deleteBtnClick(sender: UIButton) {
        selectedPhotos.removeObject(at: sender.tag)
        selectedAssets.removeObject(at: sender.tag)
        self.photoCollectionView.performBatchUpdates({
            let indexPath = NSIndexPath(item: sender.tag, section: 0)
            self.photoCollectionView.deleteItems(at: [indexPath as IndexPath])
        }) { (finish: Bool) in
            self.reloadPhotoCollectionView()
        }
    }
    
    func reloadPhotoCollectionView() {
        self.photoCollectionView.reloadData()
        let height = self.photoCollectionView.getCollectionViewHeight()
        self.delegate?.selectedPhotoCallback(selectedPhotos: self.selectedPhotos, selectedAssets: self.selectedAssets, photoCollectionViewHeight: height)
    }
    
    func pushImagePickerController() {
        let imagePickerVc: TZImagePickerController! = TZImagePickerController(maxImagesCount: 9, albumModel: albumModels, albumType: .onlyCustom, delegate: self, pushPhotoPickerVc: false)
        imagePickerVc.naviBgColor = COLOR_MAIN_APP
        imagePickerVc.selectedAssets = selectedAssets
        imagePickerVc.allowTakePicture = false
        imagePickerVc.allowPickingVideo = false
        imagePickerVc.allowPickingImage = true
        imagePickerVc.allowPickingOriginalPhoto = false
        imagePickerVc.allowPickingGif = false
        imagePickerVc.sortAscendingByModificationDate = true
        imagePickerVc.showSelectBtn = true
        imagePickerVc.allowCrop = false
        imagePickerVc.needCircleCrop = false
        
        let vc = currentviewController()
        vc?.navigationController?.present(imagePickerVc, animated: true, completion: nil)
//        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        delegate.window?.rootViewController?.present(imagePickerVc, animated: true, completion: nil)
    }
}

extension ZJASelectedPhotoCell: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        selectedAssets = NSMutableArray(array: assets)
        selectedPhotos = NSMutableArray(array: photos)
        self.isSelectOriginalPhoto = isSelectOriginalPhoto;
        photoCollectionView.reloadData()
        let height = photoCollectionView.getCollectionViewHeight()
        delegate?.selectedPhotoCallback(selectedPhotos: selectedPhotos, selectedAssets: selectedAssets, photoCollectionViewHeight: height)
    }
}
