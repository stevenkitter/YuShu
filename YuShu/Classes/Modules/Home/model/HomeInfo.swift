//
//  HomeInfo.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/6.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper
struct HomeInfo: Mappable {
    var broadcastlist: [BroadCast] = []
    var slidelist: [Slide] = []
    var imageList: [Slide] = []
    var videoList: [Slide] = []
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        broadcastlist <- map["broadcastlist"]
        slidelist <- map["slidelist"]
        imageList <- map["imageList"]
        videoList <- map["videoList"]
    }
}

struct BroadCast: Mappable {
    var broadcast_id: String?
    var broadcast_title: String?
    var broadcast_desc: String?
    var broadcast_addtime: String?
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        broadcast_id <- map["broadcast_id"]
        broadcast_title <- map["broadcast_title"]
        broadcast_desc <- map["broadcast_desc"]
        broadcast_addtime <- map["broadcast_addtime"]
    }
}

struct Slide: Mappable {
    var slide_id: String?
    var slide_title: String?
    var slide_image_path: String?
    var slide_desc: String?
    var slide_addtime: String?
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        slide_id <- map["slide_id"]
        slide_title <- map["slide_title"]
        slide_image_path <- map["slide_image_path"]
        slide_desc <- map["slide_desc"]
        slide_addtime <- map["slide_addtime"]
    }
}
