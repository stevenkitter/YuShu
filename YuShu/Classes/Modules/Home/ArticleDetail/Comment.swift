//
//  Comment.swift
//  InternManager
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper

struct Comment: Mappable {
    var comment_date = ""
    var login_time = ""
    var user_phone = ""
    var friendcircle_id = ""
    var code = ""
    var user_id = ""
    var source_type = ""
    var invitation_code = ""
    var sex = ""
    var money = ""
    var parent_id = ""
    var user_avatar = ""
    var register_time = ""
    var login_ip = ""
    var artical_id = ""
    var user_nickName = ""
    var comment_id = ""
    var user_card = ""
    var points = ""
    var source_code = ""
    var comment_content = ""
    var user_password = ""
    var role_id = ""
    var user_name = ""
    var replay: [Comment] = []
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        comment_date <- (map["comment_date"],DateTransform())
        login_time <- map["login_time"]
        user_phone <- map["user_phone"]
        friendcircle_id <- map["friendcircle_id"]
        code <- map["code"]
        user_id <- map["user_id"]
        source_type <- map["source_type"]
        invitation_code <- map["invitation_code"]
        sex <- map["sex"]
        money <- map["money"]
        parent_id <- map["parent_id"]
        user_avatar <- (map["user_avatar"], AvatarTransform())
        register_time <- map["register_time"]
        login_ip <- map["login_ip"]
        artical_id <- map["artical_id"]
        user_nickName <- map["user_nickName"]
        comment_id <- map["comment_id"]
        user_card <- map["user_card"]
        points <- map["points"]
        source_code <- map["source_code"]
        comment_content <- map["comment_content"]
        user_password <- map["user_password"]
        role_id <- map["role_id"]
        user_name <- map["user_name"]
        replay <- map["replay"]
    }
}
