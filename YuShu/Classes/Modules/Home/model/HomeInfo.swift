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
    var imagepackageList: [ImageFile] = []
    var videoList: [VideoFile] = []
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        broadcastlist <- map["broadcastlist"]
        slidelist <- map["slidelist"]
        imagepackageList <- map["imagepackageList"]
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
        slide_image_path <- (map["slide_image_path"], AvatarTransform())
        slide_desc <- map["slide_desc"]
        slide_addtime <- map["slide_addtime"]
    }
}

struct ImageFile: Mappable {
    var image_id: String?
    var image_title: String?
    var image_file_path: String?
    var image_file_path_small: String?
   
    var image_package_id: String?
    var image_package_title: String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        image_id <- map["image_id"]
        image_package_id <- map["image_package_id"]
        image_package_title <- map["image_package_title"]
        image_title <- map["image_title"]
        image_file_path <- (map["image_file_path"], AvatarTransform())
        image_file_path_small <- (map["image_file_path_small"], AvatarTransform())
    }
}

struct VideoFile: Mappable {
    var video_id: String?
    var video_title: String?
    var video_logo_path: String?
    var video_logo_path_small: String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        video_id <- map["video_id"]
        video_title <- map["video_title"]
        video_logo_path <- (map["video_logo_path"], AvatarTransform())
        video_logo_path_small <- (map["video_logo_path_small"], AvatarTransform())
    }
}

struct ImagePackage: Mappable {
    var image_id: String?
    var image_title: String?
    var image_file_path: String?
    var image_file_path_small: String?
    
    var image_package_id: String?
    var image_package_title: String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        image_id <- map["image_id"]
        image_package_id <- map["image_package_id"]
        image_package_title <- map["image_package_title"]
        image_title <- map["image_title"]
        image_file_path <- (map["image_file_path"], AvatarTransform())
        image_file_path_small <- (map["image_file_path_small"], AvatarTransform())
    }
}

