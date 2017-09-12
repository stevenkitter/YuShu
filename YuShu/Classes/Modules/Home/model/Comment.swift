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
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        comment_id <- map["comment_id"]
        
    }
}
