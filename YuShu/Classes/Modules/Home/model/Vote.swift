//
//  Vote.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/11.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper
struct Vote: Mappable{
    var vote_id: String?
    var vote_title: String?
    var vote_desc: String?
    var vote_addtime: String?
    var vote_status: String?
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        vote_id <- map["vote_id"]
        vote_title <- map["vote_title"]
        vote_desc <- map["vote_desc"]
        vote_addtime <- map["vote_addtime"]
        vote_status <- map["vote_status"]
    }
}

extension String {
    func statusImage()-> String {
        switch self {
        case "0":
            return ""
        default:
            return ""
        }
    }
}
