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

//主工程颜色
let COLOR_MAIN_APP = UIColor.colorWithHexString(hex: "00bb9c")
let COLOR_TABLE_LINE = UIColor.colorWithHexString(hex: "d9d9d9")
let COLOR_MAIN_BACKGROUND = UIColor.colorWithHexString(hex: "f5f5f5")
let COLOR_BORDER_LINE = UIColor.colorWithHexString(hex: "e6e6e6")
let COLOR_TEXT_LABEL = UIColor.colorWithHexString(hex: "999999")

//基本数据
let CONFIG_YIGUI_TYPEIMAGES = ["YiGui_Type_YiFu","YiGui_Type_KuZi","YiGui_Type_XieZi","YiGui_Type_BaoBao","YiGui_Type_PeiShi","YiGui_Type_NeiYi"]
let CONFIG_YIGUI_TYPENAMES = ["上装","下装","鞋子","包包","配饰","内衣"]

let PATH_DATABASE_FILE = NSHomeDirectory() + "/Documents/ZJADatabase.sqlite3"
let PATH_PHOTO_IMAGE = NSHomeDirectory() + "/Documents/Photo/"

let KEY_USERDEFAULT_TYPE_COUNT = "YiguiCategoriesTypeCount"
