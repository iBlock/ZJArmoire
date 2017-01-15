//
//  ZJATypeListController.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/21.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJATypeListController: UIViewController {
    
    var yiguiType:NSInteger!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareUI() {
        title = CONFIG_YIGUI_TYPENAMES[yiguiType]//self.typeTitle(type: yiguiType)
        navigationItem.rightBarButtonItem = UIBarButtonItem.rightItem(normalImage: "Global_Navi_Add", highlightedImage: "Global_Navi_Add", target: self, action: #selector(didTappedAddButton(sender:)))
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        let errorView = view.loadErrorView()
        errorView.errorButtonClick = { [weak self]() -> () in
            self?.didTappedAddButton(sender: nil)
        }
    }

//    private func typeTitle(type:NSInteger) -> String {
//        switch type {
//        case 0:
//            return "上装"
//        case 1:
//            return "下装"
//        case 2:
//            return "鞋子"
//        case 3:
//            return "包包"
//        case 4:
//            return "配饰"
//        case 5:
//            return "内衣"
//        default:
//            return "全部"
//        }
//    }
    
    // MARK: - Event and Respone
    
    @objc private func didTappedAddButton(sender:UIBarButtonItem?) {
        let selectorView = ZJAPhotoSelectorView()
        selectorView.photoTypeClick = { [weak self](type: ZJAPhotoSelectorType) -> () in
            switch type {
            case .takeImage:
                let cameraController = ZJACameraController()
                cameraController.yiguiType = self?.yiguiType
//                self?.navigationController?.present(cameraController, animated: true, completion: nil)
                self?.navigationController?.pushViewController(cameraController, animated: true)
            case .selectorImage: break
            }
        }
        selectorView.show()
    }
    
    // MARK: - Lazy Method
    

}
