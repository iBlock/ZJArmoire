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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareUI() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        view.layer.addSublayer(captureVideoViewLayer)
        view.addSubview(captureActionView)
    }
    
    private func setUpViewControllerConstraints() {
        captureActionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(100)
        }
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
        return session
    }()
    
    /** 图像预览图层 */
    private lazy var captureVideoViewLayer:AVCaptureVideoPreviewLayer = {
        let viewLayer:AVCaptureVideoPreviewLayer! = AVCaptureVideoPreviewLayer(session: self.captureSession)
        viewLayer.frame = self.view.layer.frame
        return viewLayer
    }()
    
}

extension ZJACameraController:ZJACameraActionViewDelegate {
    func didTappedCameraButton() {
        
    }

    func didTappedCancelButton() {
        dismiss(animated: true, completion: nil)
    }
}
