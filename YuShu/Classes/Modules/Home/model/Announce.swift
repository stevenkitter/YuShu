//
//  Announce.swift
//  YuShu
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper
struct Announce: Mappable {
    var adminnotice_id: String?
    var adminnotice_title: String?
    var adminnotice_addtime: String?
    var praise_id: String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        
    }
}
