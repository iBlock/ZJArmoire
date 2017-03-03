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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        ZJATableClothes().fetchAllClothes(yiguiType) { [weak self] (list) in
            self?.prepareTypeListData(list: list)
        }
    }
    
    func prepareData() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadClothesInDatabase), name: NSNotification.Name(rawValue: KEY_NOTIFICATION_REFRESH_SKU), object: nil)
    }
    
    func prepareTypeListData(list: Array<ZJAClothesModel>) {
        loadingView.stopAnimating()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem.rightItem(normalImage: "Global_Navi_Add", highlightedImage: "Global_Navi_Add", target: self, action: #selector(didTappedAddButton(sender:)))
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        view.addSubview(typeListCollectionView)
        view.addSubview(loadingView)
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
    
    @objc private func didTappedAddButton(sender:UIBarButtonItem?) {
        let addSkuVc = ZJAAddSKUController()
        addSkuVc.yiguiType = self.yiguiType
        navigationController?.pushViewController(addSkuVc, animated: true)
    }
    
    // MARK: - Lazy Method
    private lazy var typeListCollectionView: ZJATypeListCollectionView = {
        let collectionView: ZJATypeListCollectionView = ZJATypeListCollectionView(frame: self.view.bounds)
        return collectionView
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return activity
    }()
}
