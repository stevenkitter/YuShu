//
//  AroundInfo.swift
//  YuShu
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper

struct AroundInfo: Mappable {
    var around_type_id: String?
    var around_type_value: String?
    var around_type_image_path: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        around_type_image_path <- (map["around_type_image_path"], AvatarTransform())
        around_type_value <- map["around_type_value"]
        around_type_id <- map["around_type_id"]
    }
}

struct AroundDetailInfo: Mappable {
    var around_id: String?
    var around_title: String?
    var around_addtime: String?
    var around_image_path: String?
    var around_praise_count: String?
    var around_comment_count: String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        around_id <- map["around_id"]
        around_title <- map["around_title"]
        around_addtime <- map["around_addtime"]
        around_image_path <- (map["around_image_path"], AvatarTransform())
        around_praise_count <- map["around_praise_count"]
        around_comment_count <- map["around_comment_count"]
    }
}
