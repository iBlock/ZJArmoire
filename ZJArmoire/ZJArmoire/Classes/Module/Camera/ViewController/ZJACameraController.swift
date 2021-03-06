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
    
    typealias ConfirmPhotoCallback = (UIImage) -> ()
    
    var avCaptureSesstion: AVCaptureSession?
    var addPhotoBlock: ConfirmPhotoCallback?
    
    deinit {
        if cameraManager.previewLayer != nil {
            cameraManager.previewLayer?.removeFromSuperlayer()
        }
        
        maskLayer.delegate = nil
    }

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
        view.backgroundColor = UIColor.black
        cameraManager.initalSession(preview: cameraPreview)
        view.addSubview(cameraPreview)
//        view.layer.insertSublayer(maskLayer, above: cameraManager.previewLayer)
//        maskLayer.setNeedsDisplay()
        view.addSubview(cameraStartAnimalView)
        view.addSubview(captureActionView)
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
    
    lazy var cameraPreview: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-100)
        return view
    }()
    
    lazy var maskLayer: CALayer = {
        let layer = CALayer()
        layer.frame = self.view.layer.bounds
        layer.delegate = self
        return layer
    }()
    
    private lazy var captureActionView:ZJACameraActionView = {
        let actionView = ZJACameraActionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        actionView.actionViewDelegate = self
        return actionView
    }()
    
    public lazy var cameraStartAnimalView:UIImageView = {
        let animalView = UIImageView(image: UIImage(named: "Camera_Start"))
        return animalView
    }()
    
}

extension ZJACameraController:ZJACameraManagerProtocol {
    /// 相机权限认证
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
//        let image = takeImage?.compress()
        let image = takeImage?.autoResizeImage(newSize: cameraPreview.size)
        cameraEditController.previewImage = image
        cameraEditController.confirmPhotoBlock = {[weak self] (image) in
            self?.addPhotoBlock?(image)
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
        
        dismiss(animated: true, completion: nil)
    }
}

extension ZJACameraController:CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        cameraStartAnimalView.isHidden = true
        cameraStartAnimalView.removeFromSuperview()
    }
}

extension ZJACameraController: CALayerDelegate {
    func draw(_ layer: CALayer, in ctx: CGContext) {
        if layer == maskLayer {
            UIGraphicsBeginImageContextWithOptions(maskLayer.frame.size, false, 1.0)
            ctx.setFillColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor)
            ctx.fill(maskLayer.frame)
            let scanFrame = view.convert(cameraPreview.frame, from: cameraPreview.superview)
            ctx.clear(scanFrame)
        }
    }
}
