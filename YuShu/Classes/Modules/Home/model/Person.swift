//
//  Person.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/11.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper
struct Person: Mappable{
    var personnel_id: String?
    var personnel_name: String?
    var personnel_headpic: String?
    var personnel_duty: String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        personnel_id <- map["personnel_id"]
        personnel_name <- map["personnel_name"]
        personnel_headpic <- (map["personnel_headpic"],AvatarTransform())
        personnel_duty <- map["personnel_duty"]
    }
}
