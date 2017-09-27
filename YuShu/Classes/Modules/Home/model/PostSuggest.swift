//
//  PostSuggest.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/27.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper

struct PostSuggest: Mappable{
    var post_id: String?
    var post_title: String?
    var post_addtime: String?
    var post_desc: String?
    var user_id: String?
    var user_name: String?
    var user_headpic: String?
    var post_praise_count: String?
    var post_comment_count: String?
    var images: [TransferImage] = []
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        post_id <- map["post_id"]
        post_title <- map["post_title"]
        post_addtime <- map["post_addtime"]
        post_desc <- map["post_desc"]
        user_id <- map["user_id"]
        user_name <- map["user_name"]
        user_headpic <- (map["user_headpic"], AvatarTransform())
        post_praise_count <- map["post_praise_count"]
        post_comment_count <- map["post_comment_count"]
        images <- map["images"]
        
    }
}
