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
    var user_id: String?
    var user_pwd: String?
    var user_salt: String?
    var user_name: String?
    var user_name_set: String?
    var user_nickname: String?
    var user_floor: String?
    var user_room: String?
    var user_no: String?
    var user_sex: String?
    var user_headpic: String?
    var user_tel: String?
    var user_tel_set: String?
    var user_status: String?
    var user_check: String?
 
 
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        user_id <- map["user_id"]
        user_pwd <- map["user_pwd"]
        user_salt <- map["user_salt"]
        user_name <- map["user_name"]
        user_name_set <- map["user_name_set"]
        user_nickname <- map["user_nickname"]
        user_floor <- map["user_floor"]
        user_room <- map["user_room"]
        user_no <- map["user_no"]
        user_sex <- map["user_sex"]
        user_headpic <- map["user_headpic"]
        user_tel <- map["user_tel"]
        user_tel_set <- map["user_tel_set"]
        user_status <- map["user_status"]
        user_check <- map["user_check"]
     
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

