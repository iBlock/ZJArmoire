//
//  UIViewExtension.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/4.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

extension UIView {
    
    /// 获取或设置 x
    public var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    /// 获取或设置 y
    public var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    /// 获取或设置 width
    public var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    /// 获取或设置 height
    public var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    /// 获取或设置 size
    public var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }
    
    /// 获取或设置 origin
    public var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            frame.origin = newValue
        }
    }
    
}

/** 加载错误界面 */
extension UIView {
    func loadErrorView() -> ZJAErrorView {
        let errorView = ZJAErrorView(frame: bounds)
        addSubview(errorView)
        let height:CGFloat = errorView.viewHeight
        errorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(height)
            make.width.equalTo(errorView.width)
        }
        return errorView
    }
}
