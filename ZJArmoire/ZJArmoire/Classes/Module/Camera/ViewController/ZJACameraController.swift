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

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        setUpViewControllerConstraints()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.didOpenCameraAnimation(imageView: self.cameraStartAnimalView)
        }
        
//        ZJACameraManager.authorizationStatus { [weak self] (isAuthor) in
//            if isAuthor == false {
//                self?.navigationController?.popViewController(animated: true)
//            } else {
//                
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        view.layer.addSublayer(captureVideoViewLayer)
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
    private func didOpenCameraAnimation(imageView:UIImageView) {
        let animation = CATransition()
        animation.duration = 0.5
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fillMode = kCAFillModeBoth
        animation.isRemovedOnCompletion = false
        animation.type = "cameraIrisHollowOpen"
        imageView.layer.add(animation, forKey: "animation")
    }
    
    private lazy var captureActionView:ZJACameraActionView = {
        let actionView = ZJACameraActionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        actionView.actionViewDelegate = self
        return actionView
    }()
    
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
        
        return session
    }()
    
    /** 图像预览图层 */
    private lazy var captureVideoViewLayer:AVCaptureVideoPreviewLayer = {
        let viewLayer:AVCaptureVideoPreviewLayer! = AVCaptureVideoPreviewLayer(session: self.captureSession)
        viewLayer.frame = self.view.layer.frame
        return viewLayer
    }()
    
    //使用AVCaptureStillImageOutput捕获静态图片
    
    public lazy var captureStillImageOutput:AVCaptureStillImageOutput = {
        return AVCaptureStillImageOutput()
    }()
    
    public lazy var cameraStartAnimalView:UIImageView = {
        let animalView = UIImageView(image: UIImage(named: "Camera_Start"))
        return animalView
    }()
    
}

extension ZJACameraController:ZJACameraActionViewDelegate {
    func didTappedCameraButton() {
        if let videoConnection = captureStillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            captureStillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageDataSampleBuffer, error) in
                if imageDataSampleBuffer == nil {
                    return
                }
                
                let imageData:Data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                let image = UIImage(data: imageData)
                let imageEditController = ZJACameraEditController()
                imageEditController.previewImage = image
                self.navigationController?.pushViewController(imageEditController, animated: true)
            })
        }
    }

    func didTappedCancelButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension ZJACameraController:CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        cameraStartAnimalView.isHidden = true
        cameraStartAnimalView.removeFromSuperview()
    }
}
