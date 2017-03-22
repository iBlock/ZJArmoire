//
//  UIBarButtonItemExtension.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/21.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /**
     创建只带文字的item
     
     - parameter title:  标题
     - parameter target: 监听方法对象
     - parameter action: 方法选择器
     
     - returns: barButtonItem
     */
    class func leftItem(title: String, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let itemButton = UIButton(type: .custom)
        itemButton.size = CGSize(width: 50, height: 44)
        itemButton.contentHorizontalAlignment = .left
        itemButton.setTitle(title, for: .normal)
        itemButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        itemButton.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: itemButton)
    }
    
    /**
     创建只带文字的item
     
     - parameter title:  标题
     - parameter target: 监听方法对象
     - parameter action: 方法选择器
     
     - returns: barButtonItem
     */
    class func rightItem(title: String, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let itemButton = UIButton(type: .custom)
        itemButton.size = CGSize(width: 50, height: 44)
        itemButton.contentHorizontalAlignment = .right
        itemButton.setTitle(title, for: .normal)
        itemButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        itemButton.setTitleColor(UIColor.white, for: .normal)
        itemButton.setTitleColor(UIColor(white: 0.9, alpha: 1), for: .disabled)
        itemButton.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: itemButton)
    }
    
    /**
     快速创建一个图标barButtonItem 左边
     
     - parameter normalImage:      默认图片名
     - parameter highlightedImage: 高亮图片名
     - parameter target:           监听方法对象
     - parameter action:           方法选择器
     
     - returns: barButtonItem
     */
    class func leftItem(normalImage: String, highlightedImage: String, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let itemButton = UIButton(type: .custom)
        itemButton.size = CGSize(width: 50, height: 44)
        itemButton.contentHorizontalAlignment = .left
        itemButton.setImage(UIImage(named: normalImage), for: .normal)
        itemButton.setImage(UIImage(named: highlightedImage), for: .highlighted)
        itemButton.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: itemButton)
    }
    
    /**
     快速创建一个图标barButtonItem 右边
     
     - parameter normalImage:      默认图片名
     - parameter highlightedImage: 高亮图片名
     - parameter target:           监听方法对象
     - parameter action:           方法选择器
     
     - returns: barButtonItem
     */
    class func rightItem(normalImage: String, highlightedImage: String, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let itemButton = UIButton(type: .custom)
        itemButton.size = CGSize(width: 50, height: 44)
        itemButton.contentHorizontalAlignment = .right
        itemButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        itemButton.setImage(UIImage(named: normalImage), for: .normal)
        itemButton.setImage(UIImage(named: highlightedImage), for: .highlighted)
        itemButton.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: itemButton)
    }
    
    /**
     快速创建一个带标题的barButtonItem 左边
     
     - parameter title:            标题
     - parameter normalImage:      默认图片名
     - parameter highlightedImage: 高亮图片名
     - parameter target:           监听方法对象
     - parameter action:           方法选择器
     
     - returns: barButtonItem
     */
    class func item(title: String, normalImage: String, highlightedImage: String, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let itemButton = UIButton(type: .custom)
        itemButton.setTitle("返回", for: .normal)
        itemButton.size = CGSize(width: 50, height: 44)
//        itemButton.setTitleColor(UIColor.white, forState: .Normal)
//        itemButton.setTitleColor(COLOR_NAV_ITEM_HIGH, forState: .Highlighted)
        itemButton.contentHorizontalAlignment = .left
        itemButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        itemButton.setImage(UIImage(named: normalImage), for: .normal)
        itemButton.setImage(UIImage(named: highlightedImage), for: .highlighted)
        itemButton.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: itemButton)
    }
    
}

