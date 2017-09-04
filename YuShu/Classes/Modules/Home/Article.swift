//
//  Article.swift
//  InternManager
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper

struct Article: Mappable {
    var file_path: String?
    var article_imgid: String?
    var class_name: String?
    var article_id: String?
    var article_content: String?
    var article_title: String?
    var article_readcount: String?
    var article_date: String?
    var likecount: String?
    var commentcount: String?
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        file_path <- (map["file_path"],AvatarTransform())
        article_imgid <- map["article_imgid"]
        class_name <- map["class_name"]
        article_id <- map["article_id"]
        article_content <- map["article_content"]
        article_title <- map["article_title"]
        article_readcount <- map["article_readcount"]
        article_date <- (map["article_date"],DateTransform())
        likecount <- map["likecount"]
        commentcount <- map["commentcount"]
    }
}
