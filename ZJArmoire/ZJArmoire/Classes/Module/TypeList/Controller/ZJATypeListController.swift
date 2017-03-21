//
//  ZJATypeListController.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/21.
//  Copyright © 2016年 iBlock. All rights reserved.
//  单个类别衣服列表

import UIKit

class ZJATypeListController: UIViewController {
    
    var countDic: NSMutableDictionary!
    var yiguiType:Int! = 0
    var errorView: ZJAErrorView?
    var selectedAssets: NSMutableArray! = NSMutableArray()
    let userDefault = UserDefaults.standard
    var deleteClothesModels = [ZJAClothesModel]()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("%s已释放", NSStringFromClass(self.classForCoder))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        prepareData()
        setupViewConstraints()
        loadClothesInDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadClothesInDatabase() {
//        SVProgressHUD.show()
        DispatchQueue.global().async {
            let list = ZJATableClothes().fetchAllClothes(self.yiguiType)
            DispatchQueue.main.async {
//                SVProgressHUD.dismiss()
                self.prepareTypeListData(list: list)
            }
        }
    }
    
    func prepareData() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadClothesInDatabase), name: NSNotification.Name(rawValue: KEY_NOTIFICATION_REFRESH_SKU), object: nil)
    }
    
    func prepareTypeListData(list: Array<ZJAClothesModel>) {
        if let countList = userDefault.object(forKey: KEY_USERDEFAULT_TYPE_COUNT) {
            countDic = NSMutableDictionary(dictionary: countList as! NSDictionary)
        } else {
            countDic = NSMutableDictionary()
        }
        if list.count == 0 {
            errorView = view.loadErrorView()
            errorView?.errorButtonClick = { [weak self]() -> () in
                self?.didTappedAddButton(sender: nil)
            }
        } else {
            errorView?.removeFromSuperview()
        }
        countDic.setValue(String(list.count), forKey: String(yiguiType))
        userDefault.set(countDic, forKey: KEY_USERDEFAULT_TYPE_COUNT)
        typeListCollectionView.clothesModelList = list
        typeListCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareUI() {
        title = CONFIG_YIGUI_TYPENAMES[yiguiType]//self.typeTitle(type: yiguiType)
        didChangeRightBar(isDelete: false)
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        view.addSubview(typeListCollectionView)
        view.addSubview(loadingView)
    }
    
    func didChangeRightBar(isDelete: Bool) {
        if isDelete == true {
            didChangeRightButtonState(isEnable: false)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItemButton)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem.rightItem(normalImage: "Global_Navi_More", highlightedImage: "Global_Navi_More", target: self, action: #selector(didTappedMoreButton(sender:)))
        }
    }
    
    func didChangeRightButtonState(isEnable: Bool) {
        if isEnable == true {
            rightItemButton.isUserInteractionEnabled = true
            rightItemButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            rightItemButton.isUserInteractionEnabled = false
            rightItemButton.setTitleColor(UIColor.colorHex(hex: "ffffff", alpha: 0.5), for: .normal)
        }
    }
    
    private func setupViewConstraints() {
        typeListCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
    }
    
    // MARK: - Event and Respone
    
    func didTappedMoreButton(sender: UIBarButtonItem) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "添加", style: .default)
        { (action) in
            self.didTappedAddButton(sender: nil)
        }
        
        let action2 = UIAlertAction(title: "删除", style: .destructive)
        { (action) in
            self.didChangeRightBar(isDelete: true)
            self.typeListCollectionView.isDelete = true
            self.typeListCollectionView.reloadData()
        }
        
        let action3 = UIAlertAction(title: "取消", style: .cancel)
        { (action) in
            
        }
        sheet.addAction(action1)
        sheet.addAction(action2)
        sheet.addAction(action3)
        present(sheet, animated: true, completion: nil)
    }
    
    func didTappedConfirmDelete() {
        let sheet = UIAlertController(title: "删除", message: "衣服删除后将无法恢复，确认删除吗？", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .default)
        { (action) in
            self.didChangeRightBar(isDelete: false)
            self.typeListCollectionView.isDelete = false
            self.typeListCollectionView.reloadData()
            self.deleteClothesModels.removeAll()
        }
        let action2 = UIAlertAction(title: "确认", style: .destructive)
        { (action) in
            self.didChangeRightBar(isDelete: false)
            self.typeListCollectionView.isDelete = false
            
            if self.deleteClothesModels.count > 0 {
                /// 删除数据
                self.didDeleteClothesforDatabase()
                self.deleteClothesModels.removeAll()
                self.loadClothesInDatabase()
            } else {
                self.typeListCollectionView.reloadData()
            }
        }
        sheet.addAction(action1)
        sheet.addAction(action2)
        present(sheet, animated: true, completion: nil)
    }
    
    func didSelectorClothesCallback(model: ZJAClothesModel) {
        if model.isSelector == true {
            deleteClothesModels.append(model)
        } else {
            if let index = deleteClothesModels.index(of: model) {
                deleteClothesModels.remove(at: index)
            }
        }
        
        if deleteClothesModels.count > 0 {
            didChangeRightButtonState(isEnable: true)
        } else {
            didChangeRightButtonState(isEnable: false)
        }
    }
    
    @objc private func didTappedAddButton(sender:UIBarButtonItem?) {
        let addSkuVc = ZJAAddSKUController()
        addSkuVc.yiguiType = self.yiguiType
        navigationController?.pushViewController(addSkuVc, animated: true)
    }
    
    // MARK: - Lazy Method
    private lazy var typeListCollectionView: ZJATypeListCollectionView = {
        let collectionView: ZJATypeListCollectionView = ZJATypeListCollectionView(frame: self.view.bounds)
        collectionView.selectorClothesBlock = {[weak self] (model: ZJAClothesModel) in
            self?.didSelectorClothesCallback(model: model)
        }
        return collectionView
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return activity
    }()
    
    private lazy var rightItemButton: UIButton = {
        let itemButton = UIButton(type: .custom)
        itemButton.size = CGSize(width: 50, height: 44)
        itemButton.contentHorizontalAlignment = .right
        itemButton.setTitle("删除", for: .normal)
        itemButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        itemButton.setTitleColor(UIColor.white, for: .normal)
        itemButton.setTitleColor(UIColor(white: 0.9, alpha: 1), for: .disabled)
        itemButton.addTarget(self, action: #selector(didTappedConfirmDelete), for: .touchUpInside)
        return itemButton
    }()
}

/** 数据库操作 */
extension ZJATypeListController {
    func didDeleteClothesforDatabase() {
        var clothesIDList = [String]()
        for item in deleteClothesModels {
            clothesIDList.append(item.uuid)
        }
        let table = ZJATableClothes()
        _ = table.deleteClothes(clothesIdList: clothesIDList)
    }
}
