//
//  ZJAAddSKUViewModel.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/15.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation

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
            }
            //添加衣服后发送完成通知
            NotificationCenter.default.post(name: Notification.Name(KEY_NOTIFICATION_REFRESH_SKU), object: nil)
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
            let model: ZJATableClothes = ZJATableClothes()
            model.category = item.category
            model.photoName = timeStr
            model.uuid = random
            if let tagList = item.tagList {
                if tagList.count > 0 {
                    model.tagList = tagList.joined(separator: ",")
                } else {
                    model.tagList = nil
                }
            }
            let isSuccess: Bool =  model.insert()
            if isSuccess == false {
                print("保存衣服到数据库失败\n")
            } else {
                self.saveTagsToDatabase(item: item, clothesName: random)
            }
        } catch let error {
            print(error)
        }
    }
    
    func saveTagsToDatabase(item: ZJASKUItemModel, clothesName: String) {
        if let tagList = item.tagList {
            for tag in tagList {
                let tagName: String = tag
                let tagModel: ZJATableTags = ZJATableTags()
                tagModel.tagName = tagName
                let isSuccess = tagModel.insert()
                if isSuccess == false {
                    print("保存标签到数据库失败\n")
                }
                saveClothesAndTagToDatabase(tagName: tagName, clothesName: clothesName)
            }
        }
    }
    
    func saveClothesAndTagToDatabase(tagName: String, clothesName: String) {
        let clothes_tag_model = ZJATableClothes_Tag()
        clothes_tag_model.clothes_id = clothesName
        clothes_tag_model.tag_id = tagName
        let isSuccess =  clothes_tag_model.insert()
        if isSuccess == false {
            print("保存衣服标签关联表失败\n")
        }
    }
}
