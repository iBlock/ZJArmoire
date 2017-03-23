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
    var isSelecter: Bool = false
    var dapeiList: [ZJADapeiModel] = [ZJADapeiModel]()
    
    // MARK: - Life Cycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("%s已释放", NSStringFromClass(self.classForCoder))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        prepareData()
        setupViewConstraints()
        fetchDapeilistData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "搭配列表";
        let barButton = UIBarButtonItem.rightItem(title: "添加", target: self, action: #selector(didTappedAddButton(sender:)))
        tabBarController?.navigationItem.rightBarButtonItem = barButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    func prepareUI() {
        if isSelecter == true {
            title = "选择搭配"
        }
        view.backgroundColor = UIColor.white
        view.addSubview(dapeiCollectionView)
    }
    
    func prepareData() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchDapeilistData), name: NSNotification.Name(rawValue: KEY_NOTIFICATION_UPDATE_DAPEI_LIST), object: nil)
    }
    
    func setupViewConstraints() {
        dapeiCollectionView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            if isSelecter == true {
                make.bottom.equalTo(0)
            } else {
                make.bottom.equalTo(-(tabBarController?.tabBar.size.height)!)
            }
        }
    }
    
    // MARK: - Event and Respone
    
    @objc private func didTappedAddButton(sender:UIBarButtonItem?) {
        pushToAddDapeiController()
    }
    
    // 获取搭配照片数据
    func fetchAlbumModels(block: @escaping ([TZAlbumModel]) -> Void) {
        SVProgressHUD.show()
        DispatchQueue.global().async {
            let albumModels = self.fetchAllClothes()
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                block(albumModels)
            }
        }
    }
    
    // 进入添加搭配页面
    func pushToAddDapeiController() {
        fetchAlbumModels { (albumModels) in
            let addDapeiController = ZJAAddDapeiController()
            addDapeiController.albumModels = albumModels
            addDapeiController.confirmCallback = { [weak self] (isEdit) in
                if isEdit == true {
                    self?.prepareDapeiListData(dpList: (self?.dapeiList)!)
                } else {
                    self?.fetchDapeilistData()
                }
            }
            self.navigationController?.pushViewController(addDapeiController, animated: true)
        }
        /*
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
 */
    }
    
    // 进入搭配详情页面
    func pushToDapeiDetailController(dapeiModel: ZJADapeiModel) {
        let detailVc = ZJADapeiDetailController()
        detailVc.isSelecter = isSelecter
        let model: ZJADapeiModel = dapeiModel
        detailVc.dapeiModel = model
        fetchAlbumModels {[weak self] (albumModels) in
            detailVc.albumModels = albumModels
            self?.navigationController?.pushViewController(detailVc, animated: true)
        }
    }
    
    func fetchDapeilistData() {
        SVProgressHUD.show()
        DispatchQueue.global().async {
            self.dapeiList = ZJATableDapei().fetchAllDapei()
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.prepareDapeiListData(dpList: self.dapeiList)
            }
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
            dapeiCollectionView.dapeiModels = dpList
            dapeiCollectionView.reloadData()
        }
    }
    
    private lazy var dapeiCollectionView: ZJADapeiListCollectionView = {
        let collectionView: ZJADapeiListCollectionView = ZJADapeiListCollectionView(frame: self.view.bounds)
        collectionView.isSelecter = self.isSelecter
        collectionView.clickblock = { [weak self](dapeiModel: ZJADapeiModel) in
            self?.pushToDapeiDetailController(dapeiModel: dapeiModel)
        }
        return collectionView
    }()
}

extension ZJADaPeiController {
    func fetchAllClothes() -> [TZAlbumModel] {
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
