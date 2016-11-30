//
//  ZJASKUAddCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/11/29.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUAddCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareUI()
        setUpViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func getCollectionItemHeight() -> CGFloat {
        return addPhotoView.getCollectionItemHeight()
    }
    
    private func prepareUI() {
        contentView.addSubview(addPhotoView)
    }
    
    private func setUpViewConstraints() {
        addPhotoView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    private lazy var addPhotoView:ZJASKUAddPhotoView = {
        let addPhotoView:ZJASKUAddPhotoView = ZJASKUAddPhotoView(frame: self.bounds)
        return addPhotoView
    }()

}
