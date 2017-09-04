//
//  UserProfileManager.swift
//  InternManager
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
//管理用户的头像昵称
class UserProfileManager: NSObject {
    static let shareManager = UserProfileManager()
    public func initData() {
        
    }
    public func clearData() {
        
    }
    
    /// 用户唯一辨识符获取用户昵称
    ///
    /// - Parameter username: 辨识符
    /// - Returns: 昵称
    public func getNickNameWithUsername(username: String)-> String{
        return ""
    }
}
