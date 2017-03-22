//
//  ZJAAddDapeiController.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/15.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJAAddDapeiController: UIViewController {
    
    typealias ConfirmButtonCallback = () -> Void
    var albumModels: [TZAlbumModel]!
    var confirmCallback: ConfirmButtonCallback?
    var isEdit: Bool = false

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
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        view.addSubview(dapeiTableView)
        view.addSubview(confirmButton)
    }
    
    func setUpViewConstraints() {
        dapeiTableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(confirmButton.snp.top).offset(-10)
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.bottom.equalTo(-10)
        }
    }
    
    func didTappedConfirmButton() {
        saveDapeiToDatabase()
    }
    
    func didTappedCancelButton() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    public lazy var dapeiTableView: ZJANewDapeiTableView = {
        let tableView = ZJANewDapeiTableView(frame: CGRect.zero, style: .plain)
        tableView.albumModels = self.albumModels
        return tableView
    }()
    
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

extension ZJAAddDapeiController {
    func saveDapeiToDatabase() {
        let model = dapeiTableView.dapeiModel
        if model.clothesIdList == nil {
            SVProgressHUD.showError(withStatus: "你还没有选择单品哦!")
            return
        }

        let dapeiTable = ZJATableDapei()
        dapeiTable.clothesIdList = model.clothesIdList
        dapeiTable.dapei_taglist = model.taglist
        dapeiTable.dapei_date = String.getNowDateStr()
        let isSuccess = dapeiTable.insert()
        if isSuccess == true {
            confirmCallback?()
            _ = navigationController?.popViewController(animated: true)
        } else {
            SVProgressHUD.showError(withStatus: "保存搭配到数据库失败。")
        }
    }
}
