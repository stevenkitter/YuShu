//
//  FitmentType.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/25.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper

struct FitmentType: Mappable{
    var guide_type_id: String?
    var guide_type_value: String?
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        guide_type_id <- map["guide_type_id"]
        guide_type_value <- map["guide_type_value"]
        
    }
}

struct Fitment: Mappable{
    var guide_id: String?
    var guide_title: String?
    var guide_addtime: String?
    var guide_image_path: String?
    var guide_praise_count: String?
    var guide_comment_count: String?
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        guide_id <- map["guide_id"]
        guide_title <- map["guide_title"]
        guide_addtime <- map["guide_addtime"]
        guide_image_path <- (map["guide_image_path"],AvatarTransform())
        guide_praise_count <- map["guide_praise_count"]
        guide_comment_count <- map["guide_comment_count"]
    }
}



struct FitmentData: Mappable {
    var total_count: String?
    var page_count: String?
    var list: [Fitment] = []
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        total_count <- map["total_count"]
        page_count <- map["page_count"]
        list <- map["list"]
    }
}



