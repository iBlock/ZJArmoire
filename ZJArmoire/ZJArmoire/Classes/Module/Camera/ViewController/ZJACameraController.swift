//
//  ZJACameraController.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/10/18.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit
import AVFoundation

class ZJACameraController: UIViewController {
    
    typealias ConfirmPhotoCallback = () -> ()
    
    var avCaptureSesstion: AVCaptureSession?
    var addPhotoBlock: ConfirmPhotoCallback?
//    var typeName: String?
    var yiguiType:NSInteger?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        setUpViewControllerConstraints()
        cameraManager.checkAuthorizationStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraManager.startTakePhoto()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cameraManager.StopTakePhoto()
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
        cameraManager.initalSession(preview: self.view)
        view.addSubview(cameraStartAnimalView)
        view.addSubview(captureActionView)
        
        if yiguiType == nil {
            yiguiType = 0
        }
    }
    
    private func setUpViewControllerConstraints() {
        captureActionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(100)
        }
        
        cameraStartAnimalView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(captureActionView.snp.top)
        }
    }
    
    // MARK: - Event and Respone
    
    /** 打开相机动画 */
    func didOpenCameraAnimation(imageView:UIImageView) {
        let animation = CATransition()
        animation.duration = 0.5
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fillMode = kCAFillModeBoth
        animation.isRemovedOnCompletion = false
        animation.type = "cameraIrisHollowOpen"
        imageView.layer.add(animation, forKey: "animation")
    }
    
    public lazy var cameraManager:ZJACameraManager = {
        let manager = ZJACameraManager()
        manager.cameraManagerDelegate = self
        return manager
    }()
    
    private lazy var captureActionView:ZJACameraActionView = {
        let actionView = ZJACameraActionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        actionView.actionViewDelegate = self
        return actionView
    }()
    
    /*
    /** 获取拍照设备 */
    private lazy var captureDevice:AVCaptureDevice = {
        var device:AVCaptureDevice! = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            try device.lockForConfiguration()
        } catch {
            
        }
        
        return device
    }()
    
    /** 获取硬件输入流 */
    private lazy var captureDeviceInput:AVCaptureDeviceInput = {
        var deviceInput:AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: self.captureDevice)
        } catch let error as NSError {
            print(error)
        }
        return deviceInput
    }()
    
    /** 协调输入和输出的会话 */
    private lazy var captureSession:AVCaptureSession = {
        let session = AVCaptureSession()
        if session.canAddInput(self.captureDeviceInput) {
            session.addInput(self.captureDeviceInput)
        }
        
        if session.canAddOutput(self.captureStillImageOutput) {
            session.addOutput(self.captureStillImageOutput)
        }
        
        self.avCaptureSesstion = session
        
        return session
    }()
    
    /** 图像预览图层 */
    lazy var captureVideoViewLayer:AVCaptureVideoPreviewLayer = {
        let viewLayer:AVCaptureVideoPreviewLayer! = AVCaptureVideoPreviewLayer(session: self.captureSession)
        viewLayer.frame = self.view.layer.frame
        return viewLayer
    }()
    
    //使用AVCaptureStillImageOutput捕获静态图片
    
    public lazy var captureStillImageOutput:AVCaptureStillImageOutput = {
        return AVCaptureStillImageOutput()
    }()
 */
    
    public lazy var cameraStartAnimalView:UIImageView = {
        let animalView = UIImageView(image: UIImage(named: "Camera_Start"))
        return animalView
    }()
    
}

extension ZJACameraController:ZJACameraManagerProtocol {
    func cameraAuthorResult(manager: ZJACameraManager) {
        if manager.isAuthor == true {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.8, execute: {
                self.didOpenCameraAnimation(imageView: self.cameraStartAnimalView)
            })
        } else {
            let alertView = UIAlertController(title: "请打开相机权限", message: "设置-隐私-相机", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            alertView.addAction(cancelAction)
            alertView.addAction(okAction)
            self.navigationController?.present(alertView, animated: true, completion: nil)
        }
    }
    
    func cameraTakePhoneResult(manager: ZJACameraManager) {
        let takeImage = manager.takePhoneImage
        let cameraEditController = ZJACameraEditController()
        let image = takeImage?.compress()
        cameraEditController.previewImage = image
        cameraEditController.type = self.yiguiType
        cameraEditController.confirmPhotoBlock = {[weak self] () in
            self?.addPhotoBlock?()
        }
        navigationController?.pushViewController(cameraEditController, animated: true)
    }
}

extension ZJACameraController:ZJACameraActionViewDelegate {
    func didTappedCameraButton() {
        cameraManager.takePhoto()
    }

    func didTappedCancelButton() {
        //等相机启动后才可以退出，否则影响动画效果
        if cameraStartAnimalView.isHidden == false {
            return
        }
        let viewControllers:NSArray = (self.navigationController?.viewControllers)! as NSArray
        if viewControllers.count > 1 {
            if viewControllers.object(at: viewControllers.count-1) as! ZJACameraController == self {
                _ = navigationController?.popViewController(animated: true)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension ZJACameraController:CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        cameraStartAnimalView.isHidden = true
        cameraStartAnimalView.removeFromSuperview()
    }
}
