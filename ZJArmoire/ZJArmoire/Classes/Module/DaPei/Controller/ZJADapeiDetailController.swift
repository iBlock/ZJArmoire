//
//  ZJADapeiDetailController.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/1.
//  Copyright © 2017年 iBlock. All rights reserved.
//  搭配详情页

import UIKit

class ZJADapeiDetailController: UIViewController {
    
    var isSelecter: Bool = false
    var dapeiModel: ZJADapeiModel!
    var albumModels: [TZAlbumModel]!
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
        navigationItem.rightBarButtonItem = UIBarButtonItem.rightItem(normalImage: "Global_Navi_More", highlightedImage: "Global_Navi_More", target: self, action: #selector(didTappedMoreButton(sender:)))
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        view.addSubview(dapeiCollectionView)
    }
    
    /// 更新编辑后的搭配数据
    func updateEditDapeiModel(editVc: ZJAAddDapeiController) {
        dapeiModel = editVc.editDapeiMdoel
        let dpId = dapeiModel.dapei_id
        let dapeiTable = ZJATableDapei()
        SVProgressHUD.show()
        DispatchQueue.global().async {
            self.dapeiModel = dapeiTable.fetchDapei(dpId: dpId!)
            DispatchQueue.main.async {
                self.dapeiCollectionView.reloadData()
            }
        }
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

// MARK: - UICollectionViewDelegate
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
        // 根据衣服ID列表顺序来显示衣服
        let clothesId = dapeiModel.clothesIdList[indexPath.row]
        for clothes in dapeiModel.clothesList {
            if clothes.uuid == clothesId {
                cell.configCell(clothesModel: clothes)
                break
            }
        }
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

// MARK: - 点击事件
extension ZJADapeiDetailController {
    /// 点击今天穿按钮
    func didTappedConfirmButton() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: KEY_NOTIFICATION_SELECTER_DAPEI), object: dapeiModel)
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    /// 点击导航条更多按钮
    func didTappedMoreButton(sender: UIButton) {
        let sheet = UIAlertController(title: "编辑搭配", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "修改", style: .default)
        { (action) in
            let editVc = ZJAAddDapeiController()
            editVc.isEdit = true
            editVc.editDapeiMdoel = self.dapeiModel
            editVc.confirmCallback = {[weak self] (isEdit) in
                self?.updateEditDapeiModel(editVc: editVc)
            }
            editVc.albumModels = self.albumModels
            let naviVc = ZJANavigationController(rootViewController: editVc)
            self.navigationController?.present(naviVc, animated: true, completion: nil)
        }
        
        let action2 = UIAlertAction(title: "删除", style: .destructive)
        { (action) in
            self.didTappedDeleteAction()
        }
        
        let action3 = UIAlertAction(title: "取消", style: .cancel)
        { (action) in
            
        }
        sheet.addAction(action1)
        sheet.addAction(action2)
        sheet.addAction(action3)
        present(sheet, animated: true, completion: nil)
    }
    
    /// 点击删除搭配操作
    func didTappedDeleteAction() {
        let sheet = UIAlertController(title: "确定要删除吗", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "确定", style: .destructive) { (action) in
            self.deleteDapei()
        }
        let action2 = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        sheet.addAction(action1)
        sheet.addAction(action2)
        present(sheet, animated: true, completion: nil)
    }
}

// MARK: - 数据库操作
extension ZJADapeiDetailController {
    func deleteDapei() {
        let table = ZJATableDapei()
        DispatchQueue.global().async {
            let isSuccess = table.deleteDapei(dpIdList: [self.dapeiModel.dapei_id])
            DispatchQueue.main.async {
                if isSuccess == true {
                    SVProgressHUD.showSuccess(withStatus: "删除成功")
                    _ = self.navigationController?.popViewController(animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: "删除搭配失败，请重新尝试!")
                }
            }
        }
    }
}
