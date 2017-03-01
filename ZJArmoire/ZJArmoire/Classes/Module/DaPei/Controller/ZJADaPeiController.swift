//
//  ZJADaPeiController.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/4.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJADaPeiController: UIViewController {
    
    var errorView: ZJAErrorView?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        setupViewConstraints()
        fetchDapeilistData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "搭配列表";
    }
    
    func prepareUI() {
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem.rightItem(normalImage: "Global_Navi_Add", highlightedImage: "Global_Navi_Add", target: self, action: #selector(didTappedAddButton(sender:)))
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        view.addSubview(dapeiCollectionView)
    }
    
    func setupViewConstraints() {
        dapeiCollectionView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-(tabBarController?.tabBar.size.height)!)
        }
    }
    
    // MARK: - Event and Respone
    
    @objc private func didTappedAddButton(sender:UIBarButtonItem?) {
        pushToAddDapeiController()
    }
    
    func pushToAddDapeiController() {
        SVProgressHUD.show()
        DispatchQueue.global().async {
            let albumModels = self.fetchAllClothes()
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                let addDapeiController = ZJAAddDapeiController()
                addDapeiController.albumModels = albumModels
                addDapeiController.confirmCallback = { [weak self] () in
                    self?.fetchDapeilistData()
                }
                self.navigationController?.pushViewController(addDapeiController, animated: true)
            }
        }
    }
    
    func fetchDapeilistData() {
        SVProgressHUD.show()
        ZJATableDapei().fetchAllDapei { [weak self] (dapeiList) in
            SVProgressHUD.dismiss()
            self?.prepareDapeiListData(dpList: dapeiList)
        }
    }
    
    func prepareDapeiListData(dpList: [ZJADapeiModel]) {
        if dpList.count == 0 {
            errorView = view.loadErrorView()
            errorView?.errorInfoText = "您还没有衣服搭配哦，赶快去搭配吧！"
            errorView?.errorButtonClick = { [weak self]() -> () in
                self?.pushToAddDapeiController()
            }
        } else {
            errorView?.removeFromSuperview()
            dapeiCollectionView.dapeiModel = dpList
            dapeiCollectionView.reloadData()
        }
    }
    
    private lazy var dapeiCollectionView: ZJADapeiListCollectionView = {
        let collectionView: ZJADapeiListCollectionView = ZJADapeiListCollectionView(frame: self.view.bounds)
        collectionView.clickblock = { [weak self](dapeiModel: ZJADapeiModel) in
            let detailVc = ZJADapeiDetailController()
            let model: ZJADapeiModel = dapeiModel
            detailVc.clothesList = model.clothesList
            self?.navigationController?.pushViewController(detailVc, animated: true)
        }
        return collectionView
    }()
}

extension ZJADaPeiController {
    func fetchAllClothes() -> [TZAlbumModel] {
        let fetchClothesGroup = DispatchGroup()
        let clothesTable = ZJATableClothes()
        var albumModels = [TZAlbumModel]()
        for item in CONFIG_YIGUI_TYPENAMES {
            fetchClothesGroup.enter()
            let index = CONFIG_YIGUI_TYPENAMES.index(of: item)
            clothesTable.fetchAllClothes(index!, block: { (clothesModel:[ZJAClothesModel]) in
                var imageList = [UIImage]()
                for clothes in clothesModel {
                    clothes.clothesImg.imageTag = clothes.uuid
                    imageList.append(clothes.clothesImg)
                }
                let model: TZAlbumModel = TZImageManager.default().getCustomAlbum(withName: item, imageList: imageList)
                albumModels.append(model)
                fetchClothesGroup.leave()
            })
        }
        fetchClothesGroup.wait()
        return albumModels
    }
}
