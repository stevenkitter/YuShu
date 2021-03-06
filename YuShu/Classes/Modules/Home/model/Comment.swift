//
//  Comment.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/12.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper

struct Comment: Mappable{
    var comment_id: String?
    var user_id: String?
    var user_name: String?
    var user_headpic: String?
    var comment_desc: String?
    var comment_addtime: String?
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        comment_id <- map["comment_id"]
        comment_desc <- map["comment_desc"]
        comment_addtime <- map["comment_addtime"]
        user_id <- map["user_id"]
        user_name <- map["user_name"]
        user_headpic <- (map["user_headpic"], AvatarTransform())
    }
}
