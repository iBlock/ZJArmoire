//
//  ZJAEditSkuPhotoCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/16.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJAEditSkuPhotoCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(image: UIImage) {
        photoImageView.image = image
    }
    
    func prepareUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(photoImageView)
        contentView.addSubview(bottomLineView)
    }
    
    func setupViewConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(15)
        }
        
        photoImageView.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.top.equalTo(10)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        bottomLineView.snp.makeConstraints { (make) in
            make.left.equalTo(90)
            make.right.equalTo(0)
            make.top.equalTo(photoImageView.snp.bottom).offset(9.5)
            make.height.equalTo(0.5)
        }
    }
    
    func didClickPhotoImage() {
        let imagePicker = TZImagePickerController(selectedAssets: [photoImageView.image!], selectedPhotos: [photoImageView.image!], index: 0)
        imagePicker?.maxImagesCount = 1
        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appdelegate.window?.rootViewController?.present(imagePicker!, animated: true, completion: nil)
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "主图"
        titleLabel.textColor = COLOR_TEXT_LABEL
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        let panEvent = UITapGestureRecognizer(target: self, action: #selector(didClickPhotoImage))
        imageView.addGestureRecognizer(panEvent)
        return imageView
    }()
    
    private lazy var bottomLineView: UIView = {
        let line = UIView()
        line.backgroundColor = COLOR_TABLE_LINE
        return line
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
