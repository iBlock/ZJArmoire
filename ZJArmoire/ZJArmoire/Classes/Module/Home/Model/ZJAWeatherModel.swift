//
//  ZJAWeatherModel.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/5.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJAWeatherModel: NSObject {
    /** 当前温度 */
    var nowTemp: String = ""
    var dayTemp: String = ""
    var nightTemp: String = ""
    var date: String = ""
    var winddirect: String = ""
    var windpower: String = ""
    /** 空气质量 */
    var aqi: String = ""
    var updateTime: String = ""
    var updateFormatStr: String = ""
    /** 天气状况图片URL */
    var imgUrl: URL!
    var formatDateStr: String = ""
    var weekday: String = ""
    /** 天气状况，阴天还是晴天 */
    var weather: String = ""
    
    func analysisTodayWeatherData(resultDic: [String: Any]) {
        let nowDic: [String : Any] = resultDic["now"] as! [String : Any]
        let aqiDic: [String : Any] = nowDic["aqiDetail"] as! [String : Any]
        let f1Dic: [String : Any] = resultDic["f1"] as! [String : Any]
        
        nowTemp = nowDic["temperature"] as! String
        weather = nowDic["weather"] as! String
        imgUrl = URL(string: nowDic["weather_pic"] as! String)
        aqi = (String(aqiDic["aqi"] as! Int)) + " " + (aqiDic["quality"] as! String)
        
        dayTemp = f1Dic["day_air_temperature"] as! String
        nightTemp = f1Dic["night_air_temperature"] as! String
        
        winddirect = nowDic["wind_direction"] as! String
        let power = nowDic["wind_power"] as! String
        windpower = power.components(separatedBy: " ").first!
        
        date = f1Dic["day"] as! String
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyyMMdd"
        var dfdate = dformatter.date(from: date)
        dformatter.dateFormat = "MM月dd日"
        let dateStr = dformatter.string(from: dfdate!)
        formatDateStr = dateStr + " 今天"
        updateTime = resultDic["time"] as! String
        
        dformatter.dateFormat = "yyyyMMddHHmmss"
        dfdate = dformatter.date(from: updateTime)
        dformatter.dateFormat = "HH:mm"
        updateFormatStr = dformatter.string(from: dfdate!) + " 更新"
    }
    
    func analysisWeatherData(resultDic: [String: Any]) {
        dayTemp = resultDic["day_air_temperature"] as! String
        nightTemp = resultDic["night_air_temperature"] as! String
        nowTemp = nightTemp + "~" + dayTemp
        weather = resultDic["day_weather"] as! String
        
        date = resultDic["day"] as! String
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyyMMdd"
        let dfdate = dformatter.date(from: date)
        dformatter.dateFormat = "MM月dd日"
        let dateStr = dformatter.string(from: dfdate!)
        weekday = transtionWeekday(day: resultDic["weekday"] as! Int)
        formatDateStr = dateStr + " " + weekday
        winddirect = resultDic["day_wind_direction"] as! String
        let power = resultDic["day_wind_power"] as! String
        windpower = power.components(separatedBy: " ").first!
        if let js = resultDic["jiangshui"] {
            aqi = "降水概率 " + (js as! String)
        } else {
            aqi = "降水概率 0%"
        }
        
        imgUrl = URL(string: resultDic["day_weather_pic"] as! String)!
    }
    
    func transtionWeekday(day: Int) -> String! {
        switch day {
        case 1:
            return "周一"
        case 2:
            return "周二"
        case 3:
            return "周三"
        case 4:
            return "周四"
        case 5:
            return "周五"
        case 6:
            return "周六"
        case 7:
            return "周日"
        default:
            return ""
        }
    }
}
