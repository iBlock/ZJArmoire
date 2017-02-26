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
    let temperatueCellIdentifier = "temperatueCellIdentifier"
    var tagListFrame:CGRect! = CGRect(x:0,y:0,width:SCREEN_WIDTH,height:45)
    var photoCollectionViewHeight: CGFloat = WH_PHOTOCOLLECTION_WIDTH+WH_PHOTOCOLLECTION_LINESPEC*CGFloat(2)
    var albumModels: [TZAlbumModel]!
    private(set) var dapeiModel: ZJADapeiModel = ZJADapeiModel()

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
        separatorStyle = .none
        dataSource = self
        register(ZJASelectedPhotoCell.self, forCellReuseIdentifier: selectedPhotoCellIdentifier)
        register(ZJATemperatueCell.self, forCellReuseIdentifier: temperatueCellIdentifier)
    }
    
    func prepareUI() {
        backgroundColor = COLOR_MAIN_BACKGROUND
    }
    
    func setupViewConstraints() {
        
    }
    
    lazy var tagListHeaderView:ZJATaglistHeaderView = {
        let tagView: ZJATaglistHeaderView = ZJATaglistHeaderView(frame: self.tagListFrame)
        tagView.addSKUTag({ [weak self](tagNameList) in
            DispatchQueue.main.async {
                self?.reloadData()
                self?.dapeiModel.taglist = tagNameList as? Array<String>
            }
        })
        tagView.didUpdatedTagListViewFrame({ [weak self](frame) in
            self?.tagListFrame = frame
        })
        return tagView
    }()
}

extension ZJANewDapeiTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        } else if section == 1 {
            return tagListFrame.size.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 15
        }
        return 0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView,
                          heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return photoCollectionViewHeight
        } else if indexPath.section == 2 {
            return 80
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: ZJASelectedPhotoCell = tableView.dequeueReusableCell(withIdentifier: selectedPhotoCellIdentifier) as! ZJASelectedPhotoCell
            cell.delegate = self
            cell.albumModels = albumModels
            return cell
        } else if indexPath.section == 2 {
            let cell: ZJATemperatueCell = tableView.dequeueReusableCell(withIdentifier: temperatueCellIdentifier) as! ZJATemperatueCell
            cell.tempblock = { [weak self](dayTemp, nightTemp) in
                self?.dapeiModel.day_temp = dayTemp
                self?.dapeiModel.night_temp = nightTemp
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.white
            let title = UILabel()
            title.text = "单品"
            title.textColor = COLOR_TEXT_LABEL
            title.font = UIFont.systemFont(ofSize: 16)
            title.textAlignment = .left
            headerView.addSubview(title)
            
            let infoTitle = UILabel()
            infoTitle.text = "支持拖拽变更顺序"
            infoTitle.textColor = COLOR_TEXT_LABEL
            infoTitle.font = UIFont.systemFont(ofSize: 12)
            infoTitle.textAlignment = .right
            headerView.addSubview(infoTitle)
            
            let bottomLine = UIView()
            bottomLine.backgroundColor = COLOR_TABLE_LINE
            headerView.addSubview(bottomLine)
            
            title.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.centerY.equalToSuperview()
            }
            
            infoTitle.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.centerY.equalToSuperview()
            }
            
            bottomLine.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(0.5)
            })
            
            return headerView
        } else if section == 1 {
            return tagListHeaderView
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView?  {
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            
        }
    }
}

extension ZJANewDapeiTableView: ZJASelectedPhotoCellProtocol {
    func selectedPhotoCallback(selectedPhotos: NSMutableArray,
                               selectedAssets: NSMutableArray,
                               photoCollectionViewHeight: CGFloat) {
        var clothesIdList = [String]()
        for assets in selectedAssets {
            if assets is UIImage {
                let image: UIImage = assets as! UIImage
                clothesIdList.append(image.imageTag)
            }
        }
        
        self.photoCollectionViewHeight = photoCollectionViewHeight
        self.dapeiModel.clothesIdList = clothesIdList
        reloadData()
    }
}
