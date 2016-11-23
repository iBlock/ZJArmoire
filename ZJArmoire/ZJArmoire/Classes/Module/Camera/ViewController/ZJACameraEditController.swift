//
//  ZJACameraEditController.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/10/19.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJACameraEditController: UIViewController {
    
    var previewImage:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        setUpViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        let rootViewController:ZJANavigationController = UIApplication.shared.keyWindow?.rootViewController as! ZJANavigationController
        let controllers = rootViewController.viewControllers
        let controllerList:NSMutableArray = (controllers as NSArray).mutableCopy() as! NSMutableArray
//        controllers.enumerateObjects({ (object, idx, stop) in
//            let controller:UIViewController = object as! UIViewController
//            if controller.isKind(of: ZJACameraEditController.self) ||
//                controller.isKind(of: ZJACameraController.self) {
//                controllerList.remove(controller)
//            }
//        })
        controllerList.add(ZJAAddSKUController())
//        let array = NSArray.init(array: controllerList)
//        self.navigationController?.viewControllers = controllers!//controllerList as NSArray as! [UIViewController]
        rootViewController.viewControllers = controllerList as NSArray as! [UIViewController]
    }
}
