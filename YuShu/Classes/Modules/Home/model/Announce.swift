//
//  Announce.swift
//  YuShu
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper
struct Announce: Mappable {
    var adminnotice_id: String?
    var adminnotice_title: String?
    var adminnotice_addtime: String?
    var adminnotice_image_path: String?
    var adminnotice_praise_count: String?
    var adminnotice_comment_count: String?
    var praise_id: String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        adminnotice_id <- map["adminnotice_id"]
        adminnotice_title <- map["adminnotice_title"]
        adminnotice_addtime <- map["adminnotice_addtime"]
        adminnotice_image_path <- (map["adminnotice_image_path"], AvatarTransform())
        adminnotice_praise_count <- map["adminnotice_praise_count"]
        adminnotice_comment_count <- map["adminnotice_comment_count"]
    }
}


struct AnnounceInfo: Mappable {
    var total_count: String?
    var page_count: String?
    var list: [Announce] = []
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        total_count <- map["total_count"]
        page_count <- map["page_count"]
        list <- map["list"]
    }
}
