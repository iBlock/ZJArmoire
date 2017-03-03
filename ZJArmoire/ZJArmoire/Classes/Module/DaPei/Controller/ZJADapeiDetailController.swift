//
//  ZJADapeiDetailController.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/1.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJADapeiDetailController: UIViewController {
    
    var isSelecter: Bool = false
    var dapeiModel: ZJADapeiModel!
    let CellIdentifier = "ZJADapeiDetailCell"
    let CellFooterIdentifier = "ZJADapeiDetailFooterCell"
    let CellFooterIdentifier2 = "ZJADapeiDetailFooterCell2"

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        setupViewConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareUI() {
        title = "搭配详情"
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        view.addSubview(dapeiCollectionView)
    }
    
    func setupViewConstraints() {
        dapeiCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var dapeiCollectionView: ZJADapeiCollectionView = {
        let collection: ZJADapeiCollectionView = ZJADapeiCollectionView(frame: self.view.bounds)
        collection.backgroundColor = COLOR_MAIN_BACKGROUND
        collection.register(ZJADapeiDetailCell.self, forCellWithReuseIdentifier: self.CellIdentifier)
        collection.delegate = self
        collection.dataSource = self
        collection.delaysContentTouches = false
        collection.register(ZJADapeiDetailFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.CellFooterIdentifier)
        collection.register(ZJADapeiDetailFooterView2.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.CellFooterIdentifier2)
        return collection
    }()
    
}

extension ZJADapeiDetailController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dapeiModel.clothesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell: ZJADapeiDetailCell = cell as! ZJADapeiDetailCell
        cell.configCell(clothesModel: dapeiModel.clothesList[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cellIdentifier = isSelecter ? CellFooterIdentifier2 : CellFooterIdentifier
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: cellIdentifier, for: indexPath)
        if isSelecter == true {
            let button = (footer as! ZJADapeiDetailFooterView2).confirmButton
            button.addTarget(self, action: #selector(didTappedConfirmButton), for: .touchUpInside)
        }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let skuDetail = ZJAEditSkuController()
        skuDetail.clothesModel = dapeiModel.clothesList[indexPath.row]
        navigationController?.pushViewController(skuDetail, animated: true)
    }
    
}

extension ZJADapeiDetailController {
    func didTappedConfirmButton() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: KEY_NOTIFICATION_SELECTER_DAPEI), object: dapeiModel)
        _ = navigationController?.popToRootViewController(animated: true)
    }
}
