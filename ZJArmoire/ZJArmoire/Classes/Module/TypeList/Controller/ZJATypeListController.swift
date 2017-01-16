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
    var errorView: ZJAErrorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        
        let list = ZJAClothesModel().fetchAllClothes(yiguiType)
        if list?.count == 0 {
            self.errorView = view.loadErrorView()
            self.errorView?.errorButtonClick = { [weak self]() -> () in
                self?.didTappedAddButton(sender: nil)
            }
        } else {
            typeListCollectionView.clothesModelList = list!
            typeListCollectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let list = ZJAClothesModel().fetchAllClothes(yiguiType) {
            if (errorView != nil) && list.count > 0{
                errorView?.removeFromSuperview()
                typeListCollectionView.clothesModelList = list
                typeListCollectionView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareUI() {
        title = CONFIG_YIGUI_TYPENAMES[yiguiType]//self.typeTitle(type: yiguiType)
        navigationItem.rightBarButtonItem = UIBarButtonItem.rightItem(normalImage: "Global_Navi_Add", highlightedImage: "Global_Navi_Add", target: self, action: #selector(didTappedAddButton(sender:)))
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        view.addSubview(typeListCollectionView)
    }
    
    private func setupViewConstraints() {
        typeListCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
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
    private lazy var typeListCollectionView: ZJATypeListCollectionView = {
        let collectionView: ZJATypeListCollectionView = ZJATypeListCollectionView(frame: self.view.bounds)
        return collectionView
    }()

}
