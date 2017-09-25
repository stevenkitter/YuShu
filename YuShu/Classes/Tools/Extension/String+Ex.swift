//
//  String+Ex.swift
//  InternManager
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import UIKit
extension String {
    
    func dateMater()-> Date?{
        let formater = DateFormatter()
        formater.locale = NSLocale.current
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formater.date(from: self)
    }
    
    func realStr()-> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    func isRealPhoneNumber()-> Bool {
        if self.characters.count != 11 {return false}
        let reg = "^(1[0-9])\\d{9}$"
        let predict = NSPredicate(format: "SELF MATCHES %@", reg)
        return predict.evaluate(with: self)
    }
    
    func strRectMaxH(_ width: CGFloat, font: UIFont?)-> CGFloat {
        
        let nsStr = NSString(string: self)
        let rect = nsStr.boundingRect(with: CGSize(width: width, height: 8888), options: [.usesLineFragmentOrigin,.truncatesLastVisibleLine,.usesFontLeading], attributes: [NSFontAttributeName: font ?? UIFont.systemFont(ofSize: 14)], context: nil)
        return rect.size.height
    }
    
    func strRectMaxW(_ height: CGFloat, font: UIFont?)-> CGFloat {
        
        let nsStr = NSString(string: self)
        let rect = nsStr.boundingRect(with: CGSize(width: 8888, height: height), options: [.usesLineFragmentOrigin,.truncatesLastVisibleLine,.usesFontLeading], attributes: [NSFontAttributeName: font ?? UIFont.systemFont(ofSize: 14)], context: nil)
        return rect.size.width
    }
    
    
    //取末尾的字段
    func lastStr(off: Int)-> String {
        if self.characters.count == 0 {
            return "无法查询"
        }
        let from = self.index(self.endIndex, offsetBy: off)
        let subStr = self.substring(from: from)
        return subStr
    }
    //取几个值中有值的
    func exactStr(one: String, two: String) -> String {
        if self.characters.count > 0 {
            return self
        }
        if one.characters.count > 0 {
            return one
        }
        return two.lastStr(off: -4)
    }
}



extension String {
    // MARK: 1=男  2=女 3=保密
    func sex() ->String {
        switch self {
        case "1":
            return "男"
        case "2":
            return "女"
        default:
            return "保密"
        }
    }
    
    func timeStr()-> String {
        let time = Date(timeIntervalSince1970: TimeInterval(self) ?? 0)
        let timeStr = time.format(with: "yyyy-MM-dd")
        return timeStr
    }
    func timeMintStr()-> String {
        let time = Date(timeIntervalSince1970: TimeInterval(self) ?? 0)
        let timeStr = time.format(with: "yyyy-MM-dd HH:mm")
        return timeStr
    }
    func timeAgo()-> String {
        let time = Date(timeIntervalSince1970: TimeInterval(self) ?? 0)
        let str = time.timeAgoSinceNow
        return str
    }
    
    func strDate()-> Date {
        let da = Date(timeIntervalSince1970: TimeInterval(self) ?? 0)
        return da
    }
}


