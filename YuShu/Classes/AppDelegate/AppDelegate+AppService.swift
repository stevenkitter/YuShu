//
//  AppDelegate+AppService.swift
//  InternManager
//
//  Created by apple on 2017/7/31.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

//init
extension AppDelegate {
    func initSetup()  {
        //初始化
        initWindow()
        initService()
        initUserManager()
        keyboardManager()
    }
    
    func keyboardManager() {
        IQKeyboardManager.sharedManager().enable = true
    }
    
    func initWindow()  {
        self.window = UIWindow(frame: KScreenBounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = RootTabBarController()
    }
    //初始化app服务
    func initService()  {
        
        
    }
}

//notification
extension AppDelegate {
    
}
//localUser
extension AppDelegate {
    func initUserManager() -> Void {
        UserManager.shareUserManager.loadUserInfo()
    }
}

//环信
extension AppDelegate {
    
}

extension AppDelegate {
    
}
