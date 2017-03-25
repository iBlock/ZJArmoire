//
//  ZJACameraDataCenter.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/10/21.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJACameraDataCenter: NSObject {
    
    // 获取搭配照片数据
    static func fetchAlbumModels(block: @escaping ([TZAlbumModel]) -> Void) {
        SVProgressHUD.show()
        DispatchQueue.global().async {
            let albumModels = fetchAllClothes()
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                block(albumModels)
            }
        }
    }
    
    static private func fetchAllClothes() -> [TZAlbumModel] {
        let clothesTable = ZJATableClothes()
        var albumModels = [TZAlbumModel]()
        for item in CONFIG_YIGUI_TYPENAMES {
            let index = CONFIG_YIGUI_TYPENAMES.index(of: item)
            let clothesModel = clothesTable.fetchAllClothes(index!)
            var imageList = [UIImage]()
            for clothes in clothesModel {
                clothes.clothesImg.imageTag = clothes.uuid
                imageList.append(clothes.clothesImg)
            }
            let model: TZAlbumModel = TZImageManager.default().getCustomAlbum(withName: item, imageList: imageList)
            albumModels.append(model)
        }
        return albumModels
    }
}
