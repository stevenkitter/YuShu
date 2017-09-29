//
//  MYCollect.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/29.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper

struct MYCollect: Mappable {
    var collection_id: String?
    var collection_type: String?
    var collection_title: String?
    var collection_item_id: String?
    var collection_addtime: String?
    var collection_image: String?
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        collection_id <- map["collection_id"]
        collection_type <- map["collection_type"]
        collection_item_id <- map["collection_item_id"]
        collection_addtime <- map["collection_addtime"]
        collection_image <- (map["collection_image"], AvatarTransform())
        collection_title <- map["collection_title"]
    }
}
