//
//  ZJAAddSKUController.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/11/22.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit
import RxSwift

class ZJAAddSKUController: UIViewController {
    
    var yiguiType: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    deinit {
        ZJASKUDataCenter.sharedInstance.removeAllItem()
        print("%s已释放", NSStringFromClass(self.classForCoder))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.skuAddTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        setUpViewConstraints()
    }
    
    private func prepareUI() {
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        navigationItem.rightBarButtonItem = UIBarButtonItem.rightItem(title: "确定", target: self, action: #selector(didTappedConfirmButton))
        title = "添加单品"
        view.addSubview(skuAddTableView)
//        view.addSubview(confirmButton)
    }
    
    func setUpViewConstraints() {
        skuAddTableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(0)
//            make.bottom.equalTo(confirmButton.snp.top).offset(-10)
        }
        
//        confirmButton.snp.makeConstraints { (make) in
//            make.left.equalTo(15)
//            make.right.equalTo(-15)
//            make.height.equalTo(44)
//            make.bottom.equalTo(-10)
//        }
    }
    
    func didTappedConfirmButton() {
        let skuItemArray = NSArray(array: ZJASKUDataCenter.sharedInstance.skuItemArray)
        if skuItemArray.count <= 0 {
            SVProgressHUD.showInfo(withStatus: "你还没有添加衣服哦!")
            return
        }
        if filePathPrepare() == true {
            savePhoto()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    public lazy var skuAddTableView:ZJASKUAddTableView = {
        let clothesTableView:ZJASKUAddTableView = ZJASKUAddTableView(frame: self.view.bounds, style: .plain, type: self.yiguiType)
        clothesTableView.delaysContentTouches = false
        return clothesTableView
    }()
    
    // MARK: - Debug
    public func DJDebugViewController() -> ZJAAddSKUController {
        let skuDataCenter = ZJASKUDataCenter.sharedInstance
        let skuModel = ZJASKUItemModel()
        skuModel.photoImage = UIImage(named:"test")
        skuModel.category = 0
        skuDataCenter.addSKUItem(model: skuModel)
        return ZJAAddSKUController()
    }

    private lazy var confirmButton:UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("确认", for: .normal)
        let image:UIImage! = UIImage(named: "Global_Button")
        let imageInsets = UIEdgeInsetsMake(0, image.size.width/2-1, 0, image.size.height/2-1)
        let imageSel:UIImage! = UIImage(named: "Global_Button_Sel")
        let resizeImage = image.resizableImage(withCapInsets: imageInsets)
        let resizeImageSel = imageSel.resizableImage(withCapInsets: imageInsets)
        
        button.setBackgroundImage(resizeImage, for: .normal)
        button.setTitleColor(COLOR_MAIN_APP, for: .normal)
        button.setBackgroundImage(resizeImageSel, for: .highlighted)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.addTarget(self, action: #selector(didTappedConfirmButton), for: .touchUpInside)
        
        return button
    }()
}
