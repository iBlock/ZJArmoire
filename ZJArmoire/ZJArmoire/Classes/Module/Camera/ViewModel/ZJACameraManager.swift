//
//  ZJACameraManager.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/10/19.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit
import AVFoundation

class ZJACameraManager: NSObject {
    
    static func authorizationStatus(callback: @escaping (Bool)->()) {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo,completionHandler:{ (granted:Bool) -> Void in
                if granted {
                    callback(true)
                }
                else {
                    callback(false)
                }
            })

        case .authorized:
            callback(true)
        case .denied, .restricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            callback(false)
        }
    }
    
}
