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
//    var typeName: String?
    var type: Int?
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
//        let image = previewImage?.compress()
        skuModel.photoImage = previewImage
        
        /*
        //图片大小 
        let imageData = UIImageJPEGRepresentation(previewImage!, 1)        //992400
        let length: UInt = UInt(imageData!.count)
        let length2 = (previewImage?.cgImage)!.width * (previewImage?.cgImage)!.bytesPerRow
        
        let image1 = previewImage?.compress()
        let imageData3: Data = UIImageJPEGRepresentation(image1!, 1)!
        let length4 = (image1?.cgImage)!.width * (image1?.cgImage)!.bytesPerRow
        
        var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        var documentsDirectory = paths[0] 
        var filePath = documentsDirectory.appending("/1.png")
        var filePath2 = documentsDirectory.appending("/2.png")
        var filePath3 = documentsDirectory.appending("/3.png")
        
//        (imageData as! NSData).write(toFile: filePath, atomically: true)
//        (imageData2 as! NSData).write(toFile: filePath2, atomically: true)
        
//        (imageData3 as NSData).write(toFile: filePath3, atomically: true)
        do {
            try imageData?.write(to: URL(fileURLWithPath: filePath), options: .atomic)
            try imageData3.write(to: URL(fileURLWithPath: filePath3), options: .atomic)
        } catch let error {
            print(error)
        }
        */
        
        skuModel.category = type
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
