//
//  BaseApiModel.swift
//  InternManager
//
//  Created by apple on 2017/8/11.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import ObjectMapper
class BaseApiModel: Mappable {
    var status: String?
    var message: String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
    }
    
    
}
