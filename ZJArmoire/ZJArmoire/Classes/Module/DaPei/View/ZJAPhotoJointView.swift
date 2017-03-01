//
//  ZJAPhotoJointView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/15.
//  Copyright © 2017年 iBlock. All rights reserved.
//  图片拼接功能

import UIKit

class ZJAPhotoJointView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configPhotoView(photoList: [ZJAClothesModel]){
        UIGraphicsBeginImageContext(frame.size)
        let x: CGFloat = 1
        for i in 0..<3 {
            var topWidth = frame.width
            var height = frame.height*0.618
            var photoImage: UIImage
            var point: CGPoint = CGPoint.zero
            switch i {
            case 0:
                point = CGPoint.zero
                break
            case 1:
                height = frame.height-height-x
                topWidth = topWidth/2
                point = CGPoint(x: 0, y: frame.height*0.618+x)
                break
            case 2:
                height = frame.height-height-x
                topWidth = topWidth/2-x
                point = CGPoint(x: topWidth+x*2, y: frame.height*0.618+x)
            default: break
            }
            
            if i <= photoList.count-1 {
                photoImage = photoList[i].clothesImg
            } else {
                photoImage = UIImage()
            }
            
            let size = CGSize(width: topWidth, height: height)
            photoImage.draw(in: CGRect(origin: point, size: size))
        }
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        self.image = newImg
        UIGraphicsEndImageContext();
    }
    
    /*
    func configPhotoView(photoList: [ZJAClothesModel]){
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
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        self.image = newImg
        UIGraphicsEndImageContext();
    }
 */
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
