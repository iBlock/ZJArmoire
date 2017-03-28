//
//  ZJACameraZoomView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/26.
//  Copyright © 2017年 iBlock. All rights reserved.
//  照片缩放功能

import Foundation

class ZJACameraZoomView: UIView {
    
    
    init(frame: CGRect, zoomImage: UIImage) {
        super.init(frame: frame)
        prepareUI()
        configImage(image: zoomImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configImage(image: UIImage) {
        imageView.image = image
        var width = image.size.width
        var height = image.size.height
        let maxWidth = imageScrollView.bounds.size.width
        let maxHeight = imageScrollView.bounds.size.height
        
        if width > maxWidth || height > maxHeight {
            let ratio = height / width
            let maxRatio = maxHeight / maxWidth
            if ratio < maxRatio {
                width = maxWidth
                height = width*ratio
            } else {
                height = maxHeight
                width = height / ratio
            }
        }
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        imageView.center = imageScrollView.center
        imageScrollView.contentSize = imageView.size
        imageScrollView.contentInset = .zero
    }
    
    private func prepareUI() {
        addSubview(imageScrollView)
        imageScrollView.addSubview(imageView)
    }
    
    private lazy var imageScrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView(frame: self.bounds)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.black
        return scrollView
    }()
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
}

extension ZJACameraZoomView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let originalSize = scrollView.bounds.size;
        let contentSize = scrollView.contentSize;
        let offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width) / 2 : 0;
        let offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height) / 2 : 0;
        imageView.center = CGPoint(x: contentSize.width / 2 + offsetX, y: contentSize.height / 2 + offsetY)
    }
}
