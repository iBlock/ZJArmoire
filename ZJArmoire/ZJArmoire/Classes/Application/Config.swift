//
//  Config.swift
//  ZJArmoire
//
//  Created by iBlock on 16/9/30.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

let SCREEN_BOUNDS = UIScreen.main.bounds
let SCREEN_WIDTH = SCREEN_BOUNDS.width
let SCREEN_HEIGHT = SCREEN_BOUNDS.height

// MARK: - 主工程颜色
let COLOR_MAIN_APP = UIColor.colorWithHexString(hex: "0fd4c2")
let COLOR_TABLE_LINE = UIColor.colorWithHexString(hex: "d9d9d9")
let COLOR_MAIN_BACKGROUND = UIColor.colorWithHexString(hex: "f5f5f5")
let COLOR_BORDER_LINE = UIColor.colorWithHexString(hex: "e6e6e6")
let COLOR_TEXT_LABEL = UIColor.colorWithHexString(hex: "999999")

//数值计算
let WH_PHOTOCOLLECTION_LINESPEC = CGFloat(10)
let WH_PHOTOCOLLECTION_WIDTH = (SCREEN_WIDTH-2*15-10*2)/3

// MARK: - 基本数据
let CONFIG_YIGUI_TYPEIMAGES = ["YiGui_Type_YiFu","YiGui_Type_KuZi","YiGui_Type_XieZi","YiGui_Type_BaoBao","YiGui_Type_PeiShi","YiGui_Type_NeiYi"]
let CONFIG_YIGUI_TYPENAMES = ["上装","下装","鞋子","包包","配饰","内衣"]

let PATH_DATABASE_FILE = NSHomeDirectory() + "/Documents/ZJADatabase.sqlite3"
let PATH_PHOTO_IMAGE = NSHomeDirectory() + "/Documents/Photo/"

// MARK: - 本地存储KEY
let KEY_USERDEFAULT_TYPE_COUNT = "YiguiCategoriesTypeCount"

// MARK: - 通知事件KEY
//刷新衣服列表事件
let KEY_NOTIFICATION_REFRESH_SKU = "KEY_NOTIFICATION_REFRESH_SKU"
//选择今日搭配回调事件
let KEY_NOTIFICATION_SELECTER_DAPEI = "KEY_NOTIFICATION_SELECTER_DAPEI"
//刷新首页
let KEY_NOTIFICATION_REFRESH_HOME = "KEY_NOTIFICATION_REFRESH_HOME"
//更新搭配列表
let KEY_NOTIFICATION_UPDATE_DAPEI_LIST = "KEY_NOTIFICATION_UPDATE_DAPEI_LIST"
