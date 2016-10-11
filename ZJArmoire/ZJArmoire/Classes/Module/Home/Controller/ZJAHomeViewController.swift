//
//  ZJAHomeViewController.swift
//  ZJArmoire
//
//  Created by iBlock on 16/9/30.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJAHomeViewController: UIViewController {
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MAIN_BACKGROUND_COLOR
    }
    
    // MARK: - Getter and Setter
    
    private lazy var homeCollectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds)
        return collectionView
    }()

}
