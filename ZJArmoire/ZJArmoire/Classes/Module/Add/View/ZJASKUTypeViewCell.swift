//
//  ZJASKUTypeViewCell.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/12/1.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUTypeViewCell: UITableViewCell {
    
    typealias ClickTypeButtonCallback = (IndexPath) -> ()

    let SKUTypeViewCellIdentifier = "SKUTypeViewCellIdentifier"
    var itemSize:CGFloat = 0
    var clickTypeBtnBlock: ClickTypeButtonCallback?
    
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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func getItemHeight() -> CGFloat {
        return itemSize*2+5
    }
    
    private func prepareUI() {
        contentView.addSubview(skuTypeView)
    }
    
    private func setUpViewConstraints() {
        skuTypeView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    lazy var skuTypeView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let specing:CGFloat = 15
        let viewSpecing:CGFloat = 5
        layout.minimumInteritemSpacing = viewSpecing
        layout.minimumLineSpacing = viewSpecing
        layout.sectionInset = UIEdgeInsetsMake(0, specing, 0, specing)
        layout.scrollDirection = .vertical
        self.itemSize = (SCREEN_WIDTH-specing*CGFloat(2)-viewSpecing*3)/4
        layout.itemSize = CGSize(width: self.itemSize, height: self.itemSize)
        
        let typeView:UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        typeView.backgroundColor = UIColor.white
        typeView.register(ZJASKUTypeCollectionCell.self, forCellWithReuseIdentifier: self.SKUTypeViewCellIdentifier)
        typeView.isScrollEnabled = false
        typeView.delegate = self
        typeView.dataSource = self
        return typeView
    }()

}

extension ZJASKUTypeViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ZJASKUTypeCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: SKUTypeViewCellIdentifier, for: indexPath) as! ZJASKUTypeCollectionCell
        cell.configCell(index: indexPath.row)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.clickTypeBtnBlock?(indexPath)
    }
    
}


