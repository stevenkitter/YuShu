//
//  UserManager.swift
//  InternManager
//
//  Created by apple on 2017/7/31.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import ObjectMapper
import Haneke

class UserManager: NSObject {
    static let shareUserManager = UserManager()
    
    //目前缓存的用户
    var curUserInfo: UserInfo? {
        didSet {
            saveUserInfo()
        }
    }
    
    var loged: Bool {
        get {
            return curUserInfo != nil
        }
    }
    
    func logout()  {
        removeUserInfo()
    }
   
}
extension UserManager {
    //存储
    func saveUserInfo() {
        guard let curUser = self.curUserInfo else{
            return
        }
        guard let jsonStr = curUser.toJSONString(prettyPrint: true) else {
            return
        }
        let cache = Shared.stringCache
        cache.set(value: jsonStr, key: KUserCacheName)
    }
    
    //加载本地用户信息
    func loadUserInfo(){
        let cache = Shared.stringCache
        cache.fetch(key: KUserCacheName).onSuccess { (jsonStr) in
            let curUser = UserInfo(JSONString: jsonStr)
            UserManager.shareUserManager.curUserInfo = curUser
            //有本地用户 再分辨是非需要自动登录环信
            NotificationCenter.default.post(name: NotificationLoginStateChange, object: true)
        }
        
        cache.fetch(key: KUserCacheName).onFailure { (error) in
            //本地没有数据 登录吧
            NotificationCenter.default.post(name: NotificationLoginStateChange, object: false)
        }
    }
    //移除本地用户信息
    func removeUserInfo() {
        let cache = Shared.stringCache
        cache.remove(key: KUserCacheName)
        curUserInfo = nil
        NotificationCenter.default.post(name: NotificationLoginStateChange, object: false)
    }
    
}
