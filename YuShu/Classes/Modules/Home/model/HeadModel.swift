//
//  HeadModel.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/29.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper

struct HeadModel: Mappable {
    var head_image: String?
    var head_url: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        head_image <- (map["head_image"], AvatarTransform())
        head_url <- (map["head_url"], URLTransform())
        
    }
}
