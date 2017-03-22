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
    func changePhotoLocationCallback(selectedAssets: NSMutableArray)
}

class ZJASelectedPhotoCell: UITableViewCell {
    var albumModels: [TZAlbumModel]!
    var selectedPhotos: NSMutableArray = NSMutableArray()
    var selectedAssets: NSMutableArray! = NSMutableArray()
    var isSelectOriginalPhoto: Bool = false
    weak var delegate: ZJASelectedPhotoCellProtocol?
    let photoCellIdentifier = "ZJAPhotoCellIdentifier"

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
    
    func configCell(photos: NSMutableArray,
                    assets: NSMutableArray) {
        selectedAssets = assets
        selectedPhotos = photos
        photoCollectionView.reloadData( )
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
        let cell: ZJAPreviewPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! ZJAPreviewPhotoCell
        cell.videoImageView.isHidden = true
        if indexPath.row == self.selectedPhotos.count {
            cell.imageView.image = UIImage(named: "AlbumAddBtn.png")
            cell.deleteBtn.isHidden = true
            cell.gifLable.isHidden = true
        } else {
            cell.imageView.image = selectedPhotos[indexPath.row] as? UIImage
            cell.asset = selectedAssets[indexPath.row];
            cell.deleteBtn.isHidden = false
        }
        cell.gifLable.isHidden = true
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnClick(sender:)), for: .touchUpInside)
        
        return cell
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
        delegate?.changePhotoLocationCallback(selectedAssets: selectedAssets)
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
