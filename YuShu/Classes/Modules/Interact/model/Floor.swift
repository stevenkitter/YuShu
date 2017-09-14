//
//  Floor.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/14.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper

struct Floor: Mappable {
    var user_floor: String?
    var count: String?
 
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        user_floor <- map["user_floor"]
        count <- map["count"]
     
    }
}

struct Room: Mappable {
    var user_room: String?
    var user_count: String?
    var activate_count: String?
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        user_room <- map["user_room"]
        user_count <- map["user_count"]
        activate_count <- map["activate_count"]
    }
}
