//
//  ZJANewDapeiTableView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/23.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJANewDapeiTableView: UITableView {
    
    let selectedPhotoCellIdentifier = "selectedPhotoCellIdentifier"
    var photoCollectionViewHeight: CGFloat = 100

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        prepareData()
        prepareUI()
        setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareData() {
        delegate = self
        estimatedRowHeight = 50
        dataSource = self
        register(ZJASelectedPhotoCell.self, forCellReuseIdentifier: selectedPhotoCellIdentifier)
    }
    
    func prepareUI() {
        backgroundColor = COLOR_MAIN_BACKGROUND
    }
    
    func setupViewConstraints() {
        
    }
}

extension ZJANewDapeiTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return photoCollectionViewHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ZJASelectedPhotoCell = tableView.dequeueReusableCell(withIdentifier: selectedPhotoCellIdentifier) as! ZJASelectedPhotoCell
        cell.delegate = self
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell: ZJASelectedPhotoCell = tableView.dequeueReusableCell(withIdentifier: selectedPhotoCellIdentifier) as! ZJASelectedPhotoCell
    }
}

extension ZJANewDapeiTableView: ZJASelectedPhotoCellProtocol {
    func selectedPhotoCallback(selectedPhotos: NSMutableArray, photoCollectionViewHeight: CGFloat) {
        self.photoCollectionViewHeight = photoCollectionViewHeight
        reloadData()
    }
}
