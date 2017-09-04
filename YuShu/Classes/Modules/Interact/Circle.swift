//
//  Circle.swift
//  InternManager
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper

struct Circle: Mappable{
    var friend_id: String?
    var friend_content: String?
    var friend_addtime: String?
    var friend_location: String?
    
    var user_id: String?
    var user_nickname: String?
    var user_phone: String?
    var user_name: String?
    var user_avatar: String?
    
    var img:[CircleImage] = []
    var comment:[CircleComment] = []
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        friend_id <- map["friend_id"]
        friend_content <- map["friend_content"]
        friend_addtime <- (map["friend_addtime"],DateTransform())
        friend_location <- map["friend_location"]
        user_id <- map["user_id"]
        user_nickname <- map["user_nickname"]
        user_phone <- map["user_phone"]
        user_name <- map["user_name"]
        user_avatar <- (map["user_avatar"], AvatarTransform())
        img <- map["img"]
        comment <- map["comment"]
       
    }
}

struct CircleImage: Mappable {
    var file_id: String?
    var file_type: String?
    var file_path: String?
    var file_path_small: String?
    var user_id: String?
    var friend_id: String?
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        file_id <- map["file_id"]
        file_type <- map["file_type"]
        file_path <- (map["file_path"] ,AvatarTransform())
        file_path_small <- (map["file_path_small"], AvatarTransform())
        user_id <- map["user_id"]
        friend_id <- map["friend_id"]
    }
}

struct CircleComment: Mappable {
    var user_id: String?
    var comment_content: String?
    var comment_date: String?
    var user_nickname: String?
    var user_phone: String?
    var user_avatar: String?
    var comment_id: String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        user_id <- map["user_id"]
        comment_content <- map["comment_content"]
        comment_date <- (map["comment_date"],DateTransform())
        user_nickname <- map["user_nickname"]
        user_phone <- map["user_phone"]
        user_avatar <- (map["user_avatar"], AvatarTransform())
        comment_id <- map["comment_id"]
    }
}
