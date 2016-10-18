//
//  ZJATabBar.swift
//  ZJArmoire
//
//  Created by iBlock on 16/9/30.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

protocol ZJATabBarDelegate: NSObjectProtocol {
    func didTappedAddButton()
}

class ZJATabBar: UITabBar {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shadowImage = UIImage()
        addSubview(addPhoneButton)
    }
    
    /**
     重新布局tabBar子控件
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 重新布局tabBarButton
        let y: CGFloat = 0
        let width: CGFloat = SCREEN_WIDTH / 5
        let height: CGFloat = 49
        
        var index = 0
        for view in subviews {
            if !view.isKind(of: NSClassFromString("UITabBarButton")!) {
                continue
            }
            
            let x = CGFloat(index > 1 ? index + 1 : index) * width
            view.frame = CGRect(x: x, y: y, width: width, height: height)
            index += 1
        }
        
    }
    
    /**
     处理tabBar子控件的事件响应
     */

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let newPoint = self.convert(point, to: addPhoneButton)
        if addPhoneButton.point(inside: newPoint, with: event) {
            return addPhoneButton
        }
        return super.hitTest(point, with: event)
    }
    
    /// 自定义tabBar代理
    weak var tabBarDelegate: ZJATabBarDelegate?
    
    /**
     +号按钮点击事件
     */
    @objc private func didTappedAddButton(button: UIButton) {
        tabBarDelegate?.didTappedAddButton()
    }
    
    // MARK: - 懒加载
    
    private lazy var addPhoneButton: UIButton = {
        let phoneButton = UIButton(type: .custom)
        phoneButton.setImage(UIImage(named: "Global_Add_Sel"), for: .normal)
        phoneButton.setImage(UIImage(named: "Global_Add_Sel"), for: .highlighted)
        phoneButton.size = CGSize(width: SCREEN_WIDTH / 5, height: SCREEN_WIDTH / 5)
        phoneButton.center = CGPoint(x: SCREEN_WIDTH * 0.5, y: 49 * 0.5)
        phoneButton.addTarget(self, action: #selector(didTappedAddButton), for: .touchUpInside)
        return phoneButton
    }()
}
