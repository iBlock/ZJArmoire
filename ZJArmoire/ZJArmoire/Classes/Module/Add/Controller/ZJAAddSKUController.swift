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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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

extension ZJAAddSKUController: ZJASKUAddTableViewDelegate {
    func didTappedAddPhotoButton() {
        let cameraController = ZJACameraController()
        cameraController.addPhotoBlock = {[weak self]() in
            let index = NSIndexSet(index: 0)
            self?.skuAddTableView.reloadSections(index as IndexSet, with: .automatic)
        }
        navigationController?.pushViewController(cameraController, animated: true)
    }
    
    func didTappedConfirmButton() {
        if filePathPrepare() == true {
            savePhoto()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    func filePathPrepare() -> Bool {
        let fileManage = FileManager()
        var isDir: ObjCBool = false
        let isExists = fileManage.fileExists(atPath: PATH_PHOTO_IMAGE, isDirectory: &isDir)
        if isExists == false {
            do {
                try fileManage.createDirectory(at: URL.init(fileURLWithPath: PATH_PHOTO_IMAGE), withIntermediateDirectories: true, attributes: nil)
                return true
            } catch let error {
                print(error)
                return false
            }
        }
        return true
    }
    
    func savePhoto() {
        DispatchQueue.global().async {
            let skuItemArray = NSArray(array: ZJASKUDataCenter.sharedInstance.skuItemArray)
            for item in skuItemArray {
                let item: ZJASKUItemModel = item as! ZJASKUItemModel
                let now = NSDate()
                let timeInterval:TimeInterval = now.timeIntervalSince1970
                let timeStamp = Int(timeInterval)
                
                self.saveClothesToDatabase(item: item, timeStamp: timeStamp)
                self.saveTagsToDatabase(item: item, timeStamp: timeStamp)
            }
        }
    }
    
    func saveClothesToDatabase(item: ZJASKUItemModel, timeStamp: Int) {
        let image = item.photoImage
        let imageData: Data = UIImageJPEGRepresentation(image!, 1)!
        let random = String(timeStamp) + String(arc4random())
        let timeStr: String = random + ".png"
        let filePath = PATH_PHOTO_IMAGE.appending(timeStr)
        do {
            try imageData.write(to: URL(fileURLWithPath: filePath), options: .atomic)
            let model: ZJAClothesModel = ZJAClothesModel()
            model.category = item.category
            model.photoName = timeStr
            model.uuid = random
            if let tagList = item.tagList {
                model.tagList = (tagList as! Array<String>).joined(separator: ",")
            }
            let isSuccess: Bool =  model.insert()
            if isSuccess == false {
                print("保存衣服到数据库失败\n")
            }
        } catch let error {
            print(error)
        }
    }
    
    func saveTagsToDatabase(item: ZJASKUItemModel, timeStamp: Int) {
        if let tagList = item.tagList {
            for tag in tagList {
                let tagName: String = tag as! String
                let tagModel: ZJATagsModel = ZJATagsModel()
                tagModel.tagName = tagName
                let isSuccess = tagModel.insert()
                if isSuccess == false {
                    print("保存标签到数据库失败\n")
                }
                saveClothesAndTagToDatabase(tagName: tagName, timeStamp: timeStamp)
            }
        }
    }
    
    func saveClothesAndTagToDatabase(tagName: String, timeStamp: Int) {
        let clothes_tag_model = ZJAClothesTagTable()
        clothes_tag_model.clothes_id = String(timeStamp)
        clothes_tag_model.tag_id = tagName
        let isSuccess =  clothes_tag_model.insert()
        if isSuccess == false {
            print("保存衣服标签关联表失败\n")
        }
    }
}

