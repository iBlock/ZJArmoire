//
//  ZJAEditSkuController.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/15.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJAEditSkuController: UIViewController {
    
    var clothesModel: ZJAClothesModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        prepareUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        setUpViewConstraints()
    }
    
    private func prepareUI() {
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        title = "单品详情"
        view.addSubview(skuAddTableView)
    }
    
    func didTappedConfirmButton() {
    
        if rightButton.titleLabel?.text == "保存" {
            rightButton.setTitle("修改", for: .normal)
            SVProgressHUD.show()
            let model = ZJAClothesModel(skuModel: skuAddTableView.currentSKUItemModel!)
            let updateState = ZJATableClothes(model: model).update(clothesModel.uuid)
            if updateState == true {
                SVProgressHUD.showSuccess(withStatus: "修改成功")
            } else {
                SVProgressHUD.showSuccess(withStatus: "修改失败")
            }
            skuAddTableView.isEditSku = false
            skuAddTableView.isClickTypeArrowButton = false
            skuAddTableView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: KEY_NOTIFICATION_REFRESH_SKU), object: nil)
        } else {
            rightButton.setTitle("保存", for: .normal)
            skuAddTableView.isEditSku = true
            skuAddTableView.reloadData()
        }
    }
    
    func setUpViewConstraints() {
        skuAddTableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(0)
        }
    }
    
    public lazy var rightButton: UIButton = {
        let itemButton = UIButton(type: .custom)
        itemButton.size = CGSize(width: 50, height: 44)
        itemButton.contentHorizontalAlignment = .right
        itemButton.setTitle("修改", for: .normal)
        itemButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        itemButton.setTitleColor(UIColor.white, for: .normal)
        itemButton.setTitleColor(UIColor(white: 0.9, alpha: 1), for: .disabled)
        itemButton.addTarget(self, action: #selector(didTappedConfirmButton), for: .touchUpInside)
        return itemButton
    }()
    
    public lazy var skuAddTableView: ZJASkuEditTableView = {
        let clothesTableView:ZJASkuEditTableView = ZJASkuEditTableView(frame: self.view.bounds, style: .plain, model: self.clothesModel)
        clothesTableView.delaysContentTouches = false
        return clothesTableView
    }()
}
