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
    
    func strRectMaxH(_ width: CGFloat, font: UIFont?)-> CGFloat {
        
        let nsStr = NSString(string: self)
        let rect = nsStr.boundingRect(with: CGSize(width: width, height: 8888), options: [.usesLineFragmentOrigin,.truncatesLastVisibleLine,.usesFontLeading], attributes: [NSFontAttributeName: font ?? UIFont.systemFont(ofSize: 14)], context: nil)
        return rect.size.height
    }
    
    func lastStr(off: Int)-> String {
        if self.characters.count == 0 {
            return "无法查询"
        }
        let from = self.index(self.endIndex, offsetBy: off)
        let subStr = self.substring(from: from)
        return subStr
    }
    
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
