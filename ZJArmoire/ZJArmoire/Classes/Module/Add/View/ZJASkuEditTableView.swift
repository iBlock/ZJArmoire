//
//  ZJASkuEditTableView.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/15.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJASkuEditTableView: ZJASKUAddTableView {
    
    var clothesModel: ZJAClothesModel!
    var isEditSku: Bool = false
    
    let editPhotoCellIdentifier = "ZJASkuEditTableViewCell"
    
    init(frame: CGRect, style: UITableViewStyle, model: ZJAClothesModel) {
        super.init(frame: frame, style: style, type: model.type)
        clothesModel = model
        currentSKUItemModel = ZJASKUItemModel()
        currentSKUItemModel?.category = clothesModel.type
        currentSKUItemModel?.photoImage = clothesModel.clothesImg
        currentSKUItemModel?.tagList = clothesModel.tags?.components(separatedBy: ",")
    }
    
    public func updateClothes() {
        clothesModel.type = currentSKUItemModel?.category
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func fetchAddPhotoCellHeaderHeight() -> CGFloat {
        return 0
    }
    
    override func fetchAddPhotoCellFooterHeight() -> CGFloat {
        return 0
    }

    override func fetchAddPhotoCellHeight(tableView: UITableView) -> CGFloat {
        return 120
    }
    
    override func configPhotoCell(cell: UITableViewCell) {
        (cell as! ZJAEditSkuPhotoCell).configCell(clothesModel: clothesModel)
        tagListHeaderView.reset(withTags: currentSKUItemModel?.tagList)
    }
    
    override func prepareOverriteData() {
        register(ZJAEditSkuPhotoCell.self, forCellReuseIdentifier: editPhotoCellIdentifier)
    }
    
    override func customAddPhotoCell(tableView: UITableView) -> UITableViewCell {
        let cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: editPhotoCellIdentifier)
        cell?.selectionStyle = .none
        return cell!
    }
    
    override func isCanEditSku() -> Bool {
        if isEditSku == true {
            tagListHeaderView.tagTextField.isHidden = false
        } else {
            tagListHeaderView.tagTextField.isHidden = true
        }
        
        return isEditSku
    }
    
    override func fetchTagListViewHeight() -> CGFloat {
        if isEditSku == true {
            return tagListFrame.size.height
        }
        if let list = currentSKUItemModel?.tagList {
            if list.count == 0 {
                return 0
            } else {
                return tagListFrame.size.height
            }
        } else {
            return 0
        }
    }
}

extension ZJASkuEditTableView {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
