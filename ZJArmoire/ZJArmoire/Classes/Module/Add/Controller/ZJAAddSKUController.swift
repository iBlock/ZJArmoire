//
//  ZJAAddSKUController.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/11/22.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJAAddSKUController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ZJASKUDataCenter.sharedInstance.removeAllItem()
    }
    
    override func viewDidLayoutSubviews() {
        setUpViewConstraints()
    }
    
    private func prepareUI() {
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        title = "添加单品"
        view.addSubview(skuAddTableView)
    }
    
    func setUpViewConstraints() {
        
    }
    
    private lazy var skuAddTableView:ZJASKUAddTableView = {
        let clothesTableView:ZJASKUAddTableView = ZJASKUAddTableView(frame: self.view.bounds, style: .plain)
        clothesTableView.skuDelegate = self
        return clothesTableView
    }()
    
    public func DJDebugViewController() -> ZJAAddSKUController {
        let skuDataCenter = ZJASKUDataCenter.sharedInstance
        let skuModel = ZJASKUItemModel()
        skuModel.photoImage = UIImage(named:"test")
        skuModel.category = "上装"
        skuDataCenter.addSKUItem(model: skuModel)
        return ZJAAddSKUController()
    }

}

extension ZJAAddSKUController: ZJASKUAddTableViewDelegate {
    func didTappedAddPhotoButton() {
        navigationController?.pushViewController(ZJACameraController(), animated: true)
    }
}

