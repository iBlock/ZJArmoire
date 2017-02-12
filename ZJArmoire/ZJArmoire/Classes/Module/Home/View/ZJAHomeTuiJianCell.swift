//
//  ZJAHomeTuiJianCell.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/16.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJAHomeTuiJianCell: UITableViewCell {
    
    var imageList: Array<UIImage>?
    let cellIdentifier: String = "ZJAHomeCellIdentifier"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
        setUpViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func prepareUI() {
        backgroundColor = UIColor.white
        contentView.addSubview(tuiJianView)
        tuiJianView.addSubview(titleLabel)
        tuiJianView.addSubview(detailButton)
        tuiJianView.addSubview(homeCollectionView)
    }
    
    func configCell(paras: NSDictionary) {
        titleLabel.text = paras.object(forKey: "title") as! String?
        detailButton.setTitle(paras.object(forKey: "btn_title") as! String?, for: .normal)
        if let list = paras.object(forKey: "image_list") {
            imageList = list as? Array<UIImage>
        }
        homeCollectionView.reloadData()
    }
    
    private func setUpViewConstraints() {
        tuiJianView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.size.equalTo(CGSize(width: 100, height: 20))
        }
        
        detailButton.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.size.equalTo(CGSize(width: 100, height: 20))
        }
        
        homeCollectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
    
    private lazy var tuiJianView:UIView = {
        let tuijianView = UIView()
        
        let upLine = UIView()
        upLine.backgroundColor = COLOR_BORDER_LINE
        tuijianView.addSubview(upLine)
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = COLOR_BORDER_LINE
        tuijianView.addSubview(bottomLine)
        
        return tuijianView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = COLOR_TEXT_LABEL
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        return titleLabel
    }()
    
    lazy var detailButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitleColor(COLOR_TEXT_LABEL, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    private lazy var homeCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let specing:CGFloat = 5
        layout.minimumInteritemSpacing = specing
        layout.minimumLineSpacing = specing
        layout.sectionInset = UIEdgeInsetsMake(specing, specing, specing, specing)
        layout.scrollDirection = .vertical
        let itemWidth = (SCREEN_WIDTH - specing*CGFloat(4))/CGFloat(3)
        layout.itemSize = CGSize(width: itemWidth, height: 100)
        
        let collectionView: UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ZJATypelistCollectionCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
        return collectionView
    }()
}

extension ZJAHomeTuiJianCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionView:ZJATypelistCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ZJATypelistCollectionCell
        if let list = imageList {
            collectionView.configCell(image: (list[indexPath.row]))
        }
        return collectionView
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let list = imageList {
            return list.count
        } else {
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
    }
    
}
