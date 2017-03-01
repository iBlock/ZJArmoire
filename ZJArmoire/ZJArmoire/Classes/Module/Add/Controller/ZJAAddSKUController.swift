//
//  ZJAAddSKUController.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/11/22.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit
import RxSwift

class ZJAAddSKUController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    deinit {
        ZJASKUDataCenter.sharedInstance.removeAllItem()
        print("%s已释放", NSStringFromClass(self.classForCoder))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.skuAddTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        setUpViewConstraints()
    }
    
    private func prepareUI() {
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        title = "添加单品"
        view.addSubview(skuAddTableView)
        view.addSubview(confirmButton)
    }
    
    func setUpViewConstraints() {
        skuAddTableView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(confirmButton.snp.top).offset(-10)
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.bottom.equalTo(-10)
        }
    }
    
    func didTappedAddPhotoButton() {
        let selectorView = ZJAPhotoSelectorView()
        selectorView.photoTypeClick = { [weak self](type: ZJAPhotoSelectorType) -> () in
            switch type {
            case .takeImage:
                let cameraController = ZJACameraController()
                cameraController.addPhotoBlock = {[weak self]() in
                    self?.reloadAddPhotoTableView()
                }
//                self?.navigationController?.present(cameraController, animated: true, completion: nil)
                self?.navigationController?.pushViewController(cameraController, animated: true)
            case .selectorImage:
                self?.pushImagePickerController()
            }
        }
        selectorView.show()
        
        /*
        let cameraController = ZJACameraController()
        cameraController.addPhotoBlock = {[weak self]() in
            let index = NSIndexSet(index: 0)
            self?.skuAddTableView.reloadSections(index as IndexSet, with: .automatic)
        }
        navigationController?.pushViewController(cameraController, animated: true)
 */
    }
    
    func reloadAddPhotoTableView() {
        let index = NSIndexSet(index: 0)
        skuAddTableView.reloadSections(index as IndexSet, with: .automatic)
    }
    
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
        imagePickerVc.circleCropRadius = 100
        
        navigationController?.present(imagePickerVc, animated: true, completion: nil)
    }
    
    func didTappedConfirmButton() {
        if filePathPrepare() == true {
            savePhoto()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    public lazy var skuAddTableView:ZJASKUAddTableView = {
        let clothesTableView:ZJASKUAddTableView = ZJASKUAddTableView(frame: self.view.bounds, style: .plain)
        clothesTableView.delaysContentTouches = false
        clothesTableView.skuDelegate = self
        return clothesTableView
    }()
    
    // MARK: - Debug
    public func DJDebugViewController() -> ZJAAddSKUController {
        let skuDataCenter = ZJASKUDataCenter.sharedInstance
        let skuModel = ZJASKUItemModel()
        skuModel.photoImage = UIImage(named:"test")
        skuModel.category = 0
        skuDataCenter.addSKUItem(model: skuModel)
        return ZJAAddSKUController()
    }

    private lazy var confirmButton:UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("确认", for: .normal)
        let image:UIImage! = UIImage(named: "Global_Button")
        let imageInsets = UIEdgeInsetsMake(0, image.size.width/2-1, 0, image.size.height/2-1)
        let imageSel:UIImage! = UIImage(named: "Global_Button_Sel")
        let resizeImage = image.resizableImage(withCapInsets: imageInsets)
        let resizeImageSel = imageSel.resizableImage(withCapInsets: imageInsets)
        
        button.setBackgroundImage(resizeImage, for: .normal)
        button.setTitleColor(COLOR_MAIN_APP, for: .normal)
        button.setBackgroundImage(resizeImageSel, for: .highlighted)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.addTarget(self, action: #selector(didTappedConfirmButton), for: .touchUpInside)
        
        return button
    }()
}

extension ZJAAddSKUController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        let dateCenter = ZJASKUDataCenter.sharedInstance
        for item in photos {
            let skuModel = ZJASKUItemModel()
            let image = item.compress()
            skuModel.photoImage = image
            skuModel.category = 0
            dateCenter.addSKUItem(model: skuModel)
        }
        reloadAddPhotoTableView()
    }
}
