//
//  ZJAAddDapeiController.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/15.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJAAddDapeiController: UIViewController {
    
    typealias ConfirmButtonCallback = (_ isEdit:Bool) -> Void
    var albumModels: [TZAlbumModel]!
    var confirmCallback: ConfirmButtonCallback?
    /// 是否编辑状态
    var isEdit: Bool = false
    var editDapeiMdoel: ZJADapeiModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        setUpViewConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func prepareUI() {
        if isEdit == true {
            title = "编辑搭配"
            navigationItem.leftBarButtonItem = UIBarButtonItem.leftItem(title: "取消", target: self, action: #selector(didTappedCancelButton))
        } else {
            title = "新建搭配"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem.rightItem(title: "确定", target: self, action: #selector(didTappedConfirmButton))
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        view.addSubview(dapeiTableView)
//        view.addSubview(confirmButton)
    }
    
    func setUpViewConstraints() {
        dapeiTableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
//            make.bottom.equalTo(confirmButton.snp.top).offset(-10)
        }
        
        /*
        confirmButton.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.bottom.equalTo(-10)
        }
 */
    }
    
    func didTappedConfirmButton() {
        if isEdit == true {
            // 更新搭配
            updateDapeiToDatabase()
        } else {
            // 保存新搭配到数据库
            saveDapeiToDatabase()
        }
    }
    
    func didTappedCancelButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    public lazy var dapeiTableView: ZJANewDapeiTableView = {
        let tableView = ZJANewDapeiTableView(frame: CGRect.zero, style: .plain)
        tableView.albumModels = self.albumModels
        if self.isEdit == true {
            tableView.editDapeiModel = self.editDapeiMdoel
        }
        return tableView
    }()
    
    /*
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
 */
}

extension ZJAAddDapeiController {
    /// 插入搭配
    func saveDapeiToDatabase() {
        let model = dapeiTableView.dapeiModel
        if model.clothesIdList == nil {
            SVProgressHUD.showInfo(withStatus: "你还没有选择单品哦!")
            return
        }

        let dapeiTable = ZJATableDapei()
        dapeiTable.clothesIdList = model.clothesIdList
        dapeiTable.dapei_taglist = model.taglist
        dapeiTable.dapei_date = String.getNowDateStr()
        let isSuccess = dapeiTable.insert()
        if isSuccess == true {
            confirmCallback?(isEdit)
            _ = navigationController?.popViewController(animated: true)
        } else {
            SVProgressHUD.showError(withStatus: "保存搭配到数据库失败。")
        }
    }
    
    /// 更新搭配
    func updateDapeiToDatabase() {
        let model = dapeiTableView.dapeiModel
        if model.clothesIdList == nil {
            SVProgressHUD.showInfo(withStatus: "你还没有选择单品哦!")
            return
        }
        let dapeiTable = ZJATableDapei()
        dapeiTable.clothesIdList = model.clothesIdList
        dapeiTable.dapei_taglist = model.taglist
        let isSuccess = dapeiTable.update(dpId: model.dapei_id)
        if isSuccess == true {
            confirmCallback?(isEdit)
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            SVProgressHUD.showError(withStatus: "更新搭配失败，请重新尝试。")
        }
    }
}
