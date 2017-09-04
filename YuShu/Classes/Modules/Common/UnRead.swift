//
//  UnRead.swift
//  InternManager
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper

/// 红点模型
struct UnRead: Mappable {
    //提到我的 评论 推送文章
    var comment_count: Int = 0
    var message_count: Int = 0
    var article_count: Int = 0
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        comment_count <- map["comment_count"]
        message_count <- map["message_count"]
        article_count <- map["article_count"]
    }
}
