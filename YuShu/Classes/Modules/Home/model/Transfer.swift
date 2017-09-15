//
//  Transfer.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/15.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper

struct Transfer: Mappable{
    var transfer_id: String?
    var transfer_title: String?
    var transfer_addtime: String?
    var transfer_type: String?
    var user_id: String?
    var user_name: String?
    var user_headpic: String?
    var transfer_praise_count: String?
    var transfer_comment_count: String?
    var images: [TransferImage] = []
  
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        transfer_id <- map["transfer_id"]
        transfer_title <- map["transfer_title"]
        transfer_addtime <- (map["transfer_addtime"], DateTransform())
        transfer_type <- map["transfer_type"]
        user_id <- map["user_id"]
        user_name <- map["user_name"]
        user_headpic <- (map["user_headpic"], AvatarTransform())
        transfer_praise_count <- map["transfer_praise_count"]
        transfer_comment_count <- map["transfer_comment_count"]
        images <- map["images"]
    }
}

struct TransferImage: Mappable{
    var uploadimage_id: String?
    var uploadimage_path: String?
    var uploadimage_path_small: String?
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        uploadimage_id <- map["uploadimage_id"]
        uploadimage_path <- (map["uploadimage_path"], AvatarTransform())
        uploadimage_path_small <- (map["uploadimage_path_small"], AvatarTransform())
    }
}
