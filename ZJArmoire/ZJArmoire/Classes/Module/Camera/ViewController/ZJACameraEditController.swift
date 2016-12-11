//
//  ZJACameraEditController.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/10/19.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJACameraEditController: UIViewController {
    
    typealias ConfirmPhotoCallback = () -> ()
    var previewImage:UIImage?
    var isPushAddSKUController:Bool = true
    
    var confirmPhotoBlock: ConfirmPhotoCallback?

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        setUpViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // 针对添加单品页面的处理
        let keyController = UIApplication.shared.keyWindow?.rootViewController
        if (keyController?.isKind(of: ZJANavigationController.self))! {
            let rootViewController:ZJANavigationController = keyController as! ZJANavigationController
            let controllers = rootViewController.viewControllers
            for item in controllers {
                let controller:UIViewController = item
                if controller.isKind(of: ZJAAddSKUController.self) {
                    self.isPushAddSKUController = false
                    break
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareUI() {
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        view.addSubview(previewImageView)
        view.addSubview(editImageActionView)
    }
    
    private func setUpViewConstraints() {
        editImageActionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(100)
        }
        previewImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(editImageActionView.snp.top)
        }
    }
    
    // MARK: - Lazy Method
    
    private lazy var previewImageView:UIImageView = {
        let imageView = UIImageView(image: self.previewImage)
        return imageView
    }()
    
    private lazy var editImageActionView:UIView = {
        let actionView = ZJACameraEditActionView(frame:self.view.bounds)
        actionView.editImageActionDelegate = self
        return actionView
    }()

}

extension ZJACameraEditController: ZJACamereEditActionProtocol {
    
    func didTappedAgainCameraButton() {
        previewImage = nil
        self.navigationController!.popViewController(animated: true)
    }
    
    func didTappedConfirmButton() {
        let skuDataCenter = ZJASKUDataCenter.sharedInstance
        let skuModel = ZJASKUItemModel()
        skuModel.photoImage = UIImage(named:"test")
        skuModel.category = "上装"
        skuDataCenter.addSKUItem(model: skuModel)
        
        confirmPhotoBlock?()
        
        let rootViewController:ZJANavigationController = UIApplication.shared.keyWindow?.rootViewController as! ZJANavigationController
        if isPushAddSKUController == true {
            rootViewController.pushViewController(ZJAAddSKUController(), animated: false)
        }
        
        let controllers = rootViewController.viewControllers
        
        let controllerList:NSMutableArray = (controllers as NSArray).mutableCopy() as! NSMutableArray
        for item in controllers {
            let controller:UIViewController = item
            if controller.isKind(of: ZJACameraEditController.self) ||
                controller.isKind(of: ZJACameraController.self){
                controllerList.remove(controller)
            }
        }
        //下面代码是为了将modal出来的拍照界面dismiss掉，测试过如果是push出来的执行也没影响
        dismiss(animated: true, completion: nil)

        rootViewController.viewControllers = controllerList as NSArray as! [UIViewController]
    }
}
