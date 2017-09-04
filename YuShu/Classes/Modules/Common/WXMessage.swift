//
//  WXMessage.swift
//  InternManager
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper
struct WXMessage: Mappable {
    var comment_id: String?
    var article_id: String?
    var friendcircle_id: String?
    var parent_id: String?
    var comment_content: String?
    var user_id: String?
    var comment_date: String?
    var about_user_id: String?
    var about_addtime: String?
    var isread: String?
    var user_nickname: String?
    var user_name: String?
    var user_phone: String?
    var user_avatar: String?
    var register_time: String?
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        comment_id <- map["comment_id"]
        article_id <- map["article_id"]
        friendcircle_id <- map["friendcircle_id"]
        parent_id <- map["parent_id"]
        comment_content <- map["comment_content"]
        user_id <- map["user_id"]
        comment_date <- (map["comment_date"], DateTransform())
        about_user_id <- map["about_user_id"]
        about_addtime <- map["about_addtime"]
        isread <- map["isread"]
        user_nickname <- map["user_nickname"]
        user_name <- map["user_name"]
        user_phone <- map["user_phone"]
        user_avatar <- (map["user_avatar"], AvatarTransform())
        register_time <- map["register_time"]
        
    }
}
