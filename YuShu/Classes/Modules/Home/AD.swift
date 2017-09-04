//
//  AD.swift
//  InternManager
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper
struct AD: Mappable {
    var ad_title: String?
    var file_path: String?
    var ad_url: String?

    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        ad_title <- map["ad_title"]
        file_path <- (map["file_path"], AvatarTransform())
        ad_url <- map["ad_url"]
    }
}
