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
        self.window?.rootViewController = LoadingViewController()
    }
    //初始化app服务
    func initService()  {
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginStateChanged(notifi:)), name: NotificationLoginStateChange, object: nil)
    }
    
   
}

//notification
extension AppDelegate {
    func loginStateChanged(notifi: Notification) {
        if let bol = notifi.object as? Bool {
            guard bol else {
                let loginNav = RootNavigationController(rootViewController: LoginViewController())
                self.window?.rootViewController = loginNav
                return
            }
            let main = RootTabBarController()
            self.window?.rootViewController = main
        }
    }
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
