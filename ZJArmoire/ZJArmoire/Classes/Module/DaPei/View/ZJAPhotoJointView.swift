//
//  ZJAPhotoJointView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/15.
//  Copyright © 2017年 iBlock. All rights reserved.
//  图片拼接功能

import UIKit

class ZJAPhotoJointView: UIImageView {
    
    init(frame: CGRect, photoList: Array<ZJAClothesModel>!) {
        super.init(frame: frame)
        
        UIGraphicsBeginImageContext(frame.size)
        for i in 0..<3 {
            var leftHeight = frame.height
            var with = frame.width*0.618
            var photoImage: UIImage
            var point: CGPoint = CGPoint.zero
            switch i {
            case 0:
                point = CGPoint.zero
                break
            case 1:
                with = frame.width-with-0.5
                leftHeight = leftHeight/2
                point = CGPoint(x: frame.width*0.618+0.5, y: 0)
                break
            case 2:
                with = frame.width-with-0.5
                leftHeight = leftHeight/2-0.5
                point = CGPoint(x: frame.width*0.618+0.5, y: leftHeight+1)
            default: break
            }
            
            if i <= photoList.count-1 {
                photoImage = photoList[i].clothesImg
            } else {
                photoImage = UIImage()
            }
            
            let size = CGSize(width: with, height: leftHeight)
            photoImage.draw(in: CGRect(origin: point, size: size))
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
