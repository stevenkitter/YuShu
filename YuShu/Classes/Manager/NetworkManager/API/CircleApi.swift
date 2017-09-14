//
//  CircleApi.swift
//  InternManager
//
//  Created by apple on 2017/8/30.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import Moya
enum CircleApi {
    case circles(friend_id: String, user_id: String, page: Int)
    case sendComment(content: String, user_id: String, friend_id: String, about_user_id: String)
    
    
    case getFloorList()
    case getRoomList(user_floor: String)
    case getUserList(user_floor: String, user_room: String)
//    case newCircle(content: String, user_id: String, images: [WXPostImage])
}

extension CircleApi: TargetType {
    var baseURL: URL {
        return URL(string: BaseUrlStr)!
    }
    var path: String {
        switch self {
//        case .newCircle:
//            return ServiceUrlStr + "?service=User.upload_img"
        default:
            return ServiceUrlStr
        }
        
    }
    var method: Moya.Method {
        switch self {
//        case .newCircle:
//            return .post
        default:
            return .get
        }
        
    }
    var parameterEncoding: ParameterEncoding{
        return URLEncoding.default
    }
    var parameters: [String : Any]? {
        switch self {
        case let .circles(friend_id, user_id, page):
            var params: [String: Any] = [:]
            if friend_id != "" {
                params["friend_id"] = friend_id
            }
            if user_id != "" {
                params["user_id"] = user_id
            }
           
            params["page"] = page
            params["service"] = "Friend.get_friendlist"
            return params
            
        case let .sendComment(content, user_id, friend_id, about_user_id):
            var params: [String: Any] = [:]
            params["friend_id"] = friend_id
            params["content"] = content
            params["user_id"] = user_id
            params["about_user_id"] = about_user_id
            params["service"] = "Friend.send_con"
            return params
        case .getFloorList():
            var params: [String: Any] = [:]
       
            params["service"] = "User.getFloorInfo"
            return params
        case let .getRoomList(user_floor):
            var params: [String: Any] = [:]
            params["user_floor"] = user_floor
            params["service"] = "User.getRoomListByFloor"
            return params
        case let .getUserList(user_floor, user_room):
            var params: [String: Any] = [:]
            params["user_floor"] = user_floor
            params["user_room"] = user_room
            params["service"] = "User.getUserListByRoom"
            return params
        }
        
    }
    var sampleData: Data {
        
        return "Create post successfully".data(using: String.Encoding.utf8)!
        
        
    }
    var task: Task{
        switch self {
//        case let .newCircle(_, _, images):
//            var img: [MultipartFormData] = []
//            
//            for (index,item) in images.enumerated() {
//                let imageData = UIImageJPEGRepresentation(item.image!, 0.5)
//                let formData = MultipartFormData(provider: .data(imageData!), name: "file\(index+1)", fileName: item.imageName, mimeType: "image/png")
//                img.append(formData)
//            }
//            return .upload(.multipart(img))
        default:
            return .request
        }
        
    }
    
    var validate: Bool {
        return false
    }
}
