//
//  ZJACameraManager.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/10/19.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit
import AVFoundation

protocol ZJACameraManagerProtocol:NSObjectProtocol {
    func cameraAuthorResult(manager:ZJACameraManager)
    func cameraTakePhoneResult(manager:ZJACameraManager)
}

//闪光灯
enum KFlashLightState :Int {
    case KFlashLightOff = 0
    case KFlashLightOpen
    case KFlashLightAuto
    case KNoFlashLight
    
}

//聚焦
enum KFlashModeState:Int{
    case  KFlashFocusLock = 0
    case  KFlashFocusAuto
    case  KFlashFocusContinusAuto
}

enum carmerError : Error {
    case  EvievoInput
}

class ZJACameraManager: NSObject {
    private var frontCamera      :AVCaptureDevice?
    private var backCamera       :AVCaptureDevice?
    private var Orientation      :AVCaptureVideoOrientation?
    private var session          :AVCaptureSession?
    private var videoInput       :AVCaptureDeviceInput?
    private var stillImageOutput :AVCaptureStillImageOutput?
    public var previewLayer     :AVCaptureVideoPreviewLayer?
    private var flashLightState  :KFlashLightState?
    private var sessionQueue = DispatchQueue(label: "com.ZJArmoire.camera.capture_session")
    
    var isAuthor :Bool! = false
    var takePhoneImage :UIImage?
    weak var cameraManagerDelegate:ZJACameraManagerProtocol?
    
    // MARK: - Public Method
    
    
    func initalSession(preview:UIView) {
        self.session = AVCaptureSession()
        //做异常处理
        do {
            try self.videoInput = AVCaptureDeviceInput(device: self.backCarmer())
        } catch{
            print("相机启动异常")
        }
        self.stillImageOutput = AVCaptureStillImageOutput()
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
//        self.previewLayer!.frame = CGRect(x: 0, y:0, width:SCREEN_WIDTH,height:SCREEN_HEIGHT-100)
        self.previewLayer!.frame = preview.bounds
        self.previewLayer!.videoGravity = AVLayerVideoGravityResize
        preview.layer.addSublayer(self.previewLayer!)
        let outputSettings :NSDictionary = NSDictionary(object: AVVideoCodecJPEG, forKey: AVVideoCodecKey as NSCopying)
        self.stillImageOutput!.outputSettings = outputSettings as [NSObject : AnyObject]
        self.session!.sessionPreset = AVCaptureSessionPresetPhoto
        
        if self.session!.canAddInput(self.videoInput){
            self.session! .addInput(self.videoInput)
        }
        
        if self.session!.canAddOutput(self.stillImageOutput){
            self.session! .addOutput(self.stillImageOutput)
        }
    }
    
    func fontCarmer() ->AVCaptureDevice {
        return self.cameraWithPosition(position: AVCaptureDevicePosition.front)
    }
    
    func backCarmer() ->AVCaptureDevice {
        return self.cameraWithPosition(position: AVCaptureDevicePosition.back)
    }
    
    func StopTakePhoto() {
        sessionQueue.async {
            self.session? .stopRunning()
        }
    }
    func startTakePhoto() {
        sessionQueue.async {
            self.session?.startRunning()
        }
    }
    
    //转换前后摄像头
    func switchCamera() {
        
        let carmerCount :NSInteger  = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count
        if carmerCount > 1 {
            var newVideoInput :AVCaptureDeviceInput = AVCaptureDeviceInput.init()
            let position     :AVCaptureDevicePosition = self.videoInput!.device.position
            if  position == AVCaptureDevicePosition.back{
                do {
                    try newVideoInput = AVCaptureDeviceInput.init(device: self.fontCarmer())
                }catch{
                    print("error")
                }
                
            }else if position == AVCaptureDevicePosition.front{
                do {
                    try newVideoInput = AVCaptureDeviceInput.init(device: self.backCarmer())
                }catch{
                    print("error")
                }
                
            }else{
                return;
            }
            self.session!.beginConfiguration()
            self.session!.removeInput(self.videoInput)
            if(self.session!.canAddInput(newVideoInput)){
                self.session! .addInput(newVideoInput)
                self.videoInput = newVideoInput
            }else{
                self.session!.addInput(self.videoInput)
            }
            self.session! .commitConfiguration()
        }
    }
    
    // MARK: - Private Method
    
    private func cameraWithPosition(position :AVCaptureDevicePosition) -> AVCaptureDevice{
        let devices :NSArray = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as NSArray
        for device in devices {
            if((device as AnyObject).position == position) {
                return device as! AVCaptureDevice
            }
        }
        return AVCaptureDevice()
    }
    
    //拍照
    func takePhoto() {
        if let videoConnection = self.stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            self.stillImageOutput!.captureStillImageAsynchronously(from: videoConnection, completionHandler: {[weak self] (imageDataSampleBuffer, error) in
                if imageDataSampleBuffer == nil {
                    return
                }
                
                let imageData:Data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                let image = UIImage(data: imageData)
                self?.takePhoneImage = image
                self?.cameraManagerDelegate?.cameraTakePhoneResult(manager: self!)
            })
        }
    }
    
    //设置闪光灯
    func FlashLightState(state:KFlashLightState) {
        let current_camera:AVCaptureDevice = self.cameraWithPosition(position: self.videoInput!.device.position)
        if  state != KFlashLightState.KNoFlashLight {
            switch state {
            case .KFlashLightOpen:
                do {
                    try  current_camera.lockForConfiguration()
                    if current_camera.isFlashModeSupported(AVCaptureFlashMode.on){
                        current_camera.flashMode = AVCaptureFlashMode.on
                    }
                    current_camera.unlockForConfiguration()
                    
                }catch{
                    print("error")
                }
                break
            case .KFlashLightAuto:
                do {
                    try  current_camera.lockForConfiguration()
                    if current_camera.isFlashModeSupported(AVCaptureFlashMode.auto){
                        current_camera.flashMode = AVCaptureFlashMode.auto
                    }
                    current_camera.unlockForConfiguration()
                    
                }catch{
                    print("error")
                }
                break
            case .KFlashLightOff :
                do {
                    try  current_camera.lockForConfiguration()
                    if current_camera.isFlashModeSupported(AVCaptureFlashMode.off){
                        current_camera.flashMode = AVCaptureFlashMode.off
                    }
                    current_camera.unlockForConfiguration()
                    
                }catch{
                    print("error")
                }
                break
            default: break
            }
        }
        
    }
    
    func FlashModeState(state:KFlashModeState) {
        let current_camera:AVCaptureDevice = self.cameraWithPosition(position: self.videoInput!.device.position)
        switch state {
        case .KFlashFocusLock:
            do {
                try  current_camera.lockForConfiguration()
                if current_camera.isFocusModeSupported(AVCaptureFocusMode.locked){
                    current_camera.focusMode = AVCaptureFocusMode.locked
                }
                current_camera.unlockForConfiguration()
                
            }catch{
                print("error")
            }
            break
        case .KFlashFocusAuto:
            do {
                try  current_camera.lockForConfiguration()
                if current_camera.isFocusModeSupported(AVCaptureFocusMode.autoFocus){
                    current_camera.focusMode = AVCaptureFocusMode.autoFocus
                }
                current_camera.unlockForConfiguration()
                
            }catch{
                print("error")
            }
            break
        default :
            do {
                try  current_camera.lockForConfiguration()
                if current_camera.isFocusModeSupported(AVCaptureFocusMode.continuousAutoFocus){
                    current_camera.focusMode = AVCaptureFocusMode.continuousAutoFocus
                }
                current_camera.unlockForConfiguration()
                
            }catch{
                print("error")
            }
            break
        }
    }
    
    /// 检查相机权限
    func checkAuthorizationStatus() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted:Bool) in
                if granted {
                    self.isAuthor = true
                }
                else {
                    self.isAuthor = false
                }
                self.cameraManagerDelegate?.cameraAuthorResult(manager: self)
            })
            break
        case .authorized:
            self.isAuthor = true
            cameraManagerDelegate?.cameraAuthorResult(manager: self)
            break
        case .denied, .restricted:
            self.isAuthor = false
            cameraManagerDelegate?.cameraAuthorResult(manager: self)
            break
        }
    }
}
