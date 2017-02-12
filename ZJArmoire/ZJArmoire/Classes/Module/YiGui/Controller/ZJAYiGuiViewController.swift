//
//  ZJAYiGuiViewController.swift
//  ZJArmoire
//
//  Created by iBlock on 16/9/30.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJAYiGuiViewController: UIViewController {
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "衣柜";
        
        let userDefault = UserDefaults.standard
        if let countList = userDefault.object(forKey: KEY_USERDEFAULT_TYPE_COUNT) {
            yiGuiTypeCollectionView.typeCountList = countList as! NSDictionary
            yiGuiTypeCollectionView.reloadData()
        }
    }
    
    private func prepareUI() {
        view.addSubview(yiGuiTypeCollectionView)
        yiGuiTypeCollectionView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-(tabBarController?.tabBar.size.height)!)
        }
    }
    
    // MARK: - Event and Respone
    
    @objc private func rightBarButtonClick(sender:UIBarButtonItem) {
        
    }
    
    private lazy var yiGuiTypeCollectionView:ZJAYiGuiCollectionView = {
        let yiGuiTypeView = ZJAYiGuiCollectionView(frame: self.view.bounds)
        yiGuiTypeView.cellDelegate = self
        return yiGuiTypeView
    }()
    
    /*
    private lazy var rightBarButtonItem:UIBarButtonItem = {
        var addImage = UIImage(named: "Global_Add")
        addImage = addImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let barItem = UIBarButtonItem(image: addImage,
                                      style: .plain,
                                      target: self,
                                      action:#selector(ZJAYiGuiViewController.rightBarButtonClick(sender:)))
        return barItem
    }()
 */
}

extension ZJAYiGuiViewController: ZJAYiGuiTypeCellDelegate {
    func typeCellClickCallback(index: IndexPath) {
        let typeListController = ZJATypeListController()
        typeListController.yiguiType = index.row
        navigationController?.pushViewController(typeListController, animated: true)
    }
}
