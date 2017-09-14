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
    var vote_image_path: String?
    var vote_title: String?
    var vote_desc: String?
    var vote_addtime: String?
    var vote_endtime: String?
    var vote_status: String?
    var praise_user_list: [PraiseUser] = []
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        vote_id <- map["vote_id"]
        vote_image_path <- (map["vote_image_path"],AvatarTransform())
        vote_title <- map["vote_title"]
        vote_desc <- map["vote_desc"]
        vote_addtime <- map["vote_addtime"]
        vote_endtime <- map["vote_endtime"]
        vote_status <- map["vote_status"]
        praise_user_list <- map["praise_user_list"]
    }
}

struct PraiseUser: Mappable {
    var user_headpic: String?
    var user_id: String?
    var user_status: String?
    var user_name: String?
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        user_headpic <- (map["user_headpic"],AvatarTransform())
        user_id <- map["user_id"]
        user_status <- map["user_status"]
        user_name <- map["user_name"]
    }
}

struct VoteDetail: Mappable {
    var vote_title: String?
    var vote_desc: String?
    var vote_status: String?
    var vote_endtime: String?
    var vote_option_id: String?
    var vote_option: [VoteOption] = []
    var totalcount: String?
    var isVoted: Bool
    init?(map: Map) {
        isVoted = (vote_option_id ?? "").characters.count > 0
    }
    mutating func mapping(map: Map) {
        vote_title <- map["vote_title"]
        vote_desc <- map["vote_desc"]
        vote_status <- map["vote_status"]
        vote_endtime <- map["vote_endtime"]
        vote_option_id <- map["vote_option_id"]
        totalcount <- map["totalcount"]
        vote_option <- map["vote_option"]
    }
}

struct VoteOption: Mappable {
    var vote_option_id: String?
    var vote_option_desc: String?
    var count: String?
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        vote_option_id <- map["vote_option_id"]
        vote_option_desc <- map["vote_option_desc"]
        count <- map["count"]
    }
}



extension String {
    func statusImage()-> String {
        switch self {
        case "0":
            return "已结束"
        default:
            return "进行中"
        }
    }
}
