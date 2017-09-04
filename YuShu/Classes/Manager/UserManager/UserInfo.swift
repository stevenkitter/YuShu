//
//  UserInfo.swift
//  InternManager
//
//  Created by apple on 2017/7/31.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import ObjectMapper
import DateToolsSwift

class UserInfo: Mappable {
    var id: String?
    var user_nickname: String?
    var user_password: String?
    var user_name: String?
    var role_id: String?
    var user_phone: String?
    var source_type: String?
    var source_code: String?
    var sex: String?
    var invitation_code: String?
    var points: String?
    var money: String?
    var user_avatar: String?
    var register_time: String?
    var login_time: String?
    var login_ip: String?
    var user_card: String?
    var collect: String?
    var publish: String?
 
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        id <- map["user_id"]
        user_nickname <- map["user_nickname"]
        user_password <- map["user_password"]
        user_name <- map["user_name"]
        role_id <- map["role_id"]
        user_phone <- map["user_phone"]
        source_type <- map["source_type"]
        source_code <- map["source_code"]
        sex <- map["sex"]
        invitation_code <- map["invitation_code"]
        points <- map["points"]
        money <- map["money"]
        user_avatar <- (map["user_avatar"],AvatarTransform())
        register_time <- map["register_time"]
        login_time <- map["login_time"]
        login_ip <- map["login_ip"]
        user_card <- map["user_card"]
        collect <- map["collect"]
        publish <- map["publish"]
    }
    
    
}


class AvatarTransform : TransformType {
    

    
    public typealias Object = String
    
    public typealias JSON = String
    
    
    func transformFromJSON(_ value: Any?) -> String? {
        guard let valueStr = value as? String else {
            return nil
        }
        return ImageUrl + valueStr
    }
    
    func transformToJSON(_ value: String?) -> String? {
        var result = value
        guard let rang = value?.range(of: ImageUrl) else {
            return value
        }
        result?.removeSubrange(rang)
        return result
    }
    
}


class DateTransform : TransformType {
    
    
    
    public typealias Object = String
    
    public typealias JSON = String
    
    
    func transformFromJSON(_ value: Any?) -> String? {
        guard let valueStr = value as? String else {
            return nil
        }
        let dateM = valueStr.dateMater()
        
        return dateM?.timeAgoSinceNow
    }
    
    func transformToJSON(_ value: String?) -> String? {
        return value
    }
    
    
    
}



/*{
    "ret": 200,
    "data": {
        "status": "ok",
        "data": {
            "id": "22",
            "user_login": "5201314",
            "user_pass": "###48de0c9b9e76b88d532939f7c1293ac7",
            "user_email": "",
            "user_type": "student",
            "avatar": "/data/upload/admin/20170815/5992604517366.png",
            "sex": "1",
            "birthday": "2000-01-01",
            "last_login_ip": null,
            "last_login_time": "2000-01-01 00:00:00",
            "create_time": "2017-08-15 10:43:21",
            "mobile": "5201314",
            "user_nickname": "亚瑟",
            "type": "实习学生"
        },
        "msg": "登录成功"
    },
    "msg": ""
}*/

