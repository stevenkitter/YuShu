//
//  UserApi.swift
//  InternManager
//
//  Created by apple on 2017/8/1.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import Moya

let GitHubProvider = MoyaProvider<UserApi>()

enum UserApi {
   
    case login(account:String, pwd: String)
    case logout
    case userInfo(user_id: String)
    case update(user_id: String, info: String, value: String)
    case register(user_name: String, user_floor: String, user_room: String,user_tel: String)
    case getCode(tel: String)
    case updateByUserId(user_id: String, info: String, value: String)
    case uploadAva(user_id: String, image: UIImage, imageName: String)
    case getCollects(user_id: String, page: Int)
    case unRead(user_id: String)
    case myMessage(isComment: Bool,user_id: String, page: Int)
    case getPushedArticles(user_id: String, page: Int)
    case uploadImage(image: UIImage)
    
    case getMyPost(type: Int,user_id: String) //type-1:最新动态 2:闲置转让 3:公共建议
    case getMyCollection(user_id: String, page: Int)
    
    case getMyRelationWithItem(item_id: String, user_id: String, type: String)
    case getHeadInfo(type: String)
}

extension UserApi: TargetType {
    var baseURL: URL {
        return URL(string: BaseUrlStr)!
    }

    var path: String {
        switch self {
        case .login:
            return ServiceUrlStr
        case .logout:
            return ""
        case .uploadAva:
            return ServiceUrlStr + "?service=User.upload_avatar"
        case .uploadImage:
            return ServiceUrlStr + "?service=Upload.Go"
        default:
            return ServiceUrlStr
        }
    }
    var method: Moya.Method {
        switch self {
        case .login:
            return .get
        case .logout:
            return .post
        case .uploadAva:
            return .post
        case .uploadImage:
            return .post
        default:
            return .get
        }
    }
    var parameterEncoding: ParameterEncoding{
        return URLEncoding.default
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .login(account,pwd):
            var params: [String: Any] = [:]
            params["account"] = account
            params["pwd"] = pwd
            params["service"] = "User.login"
            
            return params
        case .logout:
            return nil
        case let .userInfo(user_id):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["service"] = "User.getBaseInfo"
            return params
        case let .register(user_name, user_floor, user_room, user_tel):
            var params: [String: Any] = [:]
            params["user_name"] = user_name
            params["user_floor"] = user_floor
            params["user_room"] = user_room
            params["user_tel"] = user_tel
            params["service"] = "User.register"
            return params
        case let .update(user_id, info, value):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params[info] = value
            params["service"] = "User.updateUserInfo"
            return params
        case let .getCode(tel):
            var params: [String: Any] = [:]
            params["tel"] = tel
            params["service"] = "User.get_captcha"
            return params
        case let .updateByUserId(user_id, info, value):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params[info] = value
            params["service"] = "User.update_user"
            return params
        case let .uploadAva(user_id, _, _):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            return params
            
        case let .getCollects(user_id, page):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["page"] = page
            params["service"] = "User.mycollect"
            return params
        case let .unRead(user_id):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["service"] = "Friend.mycount"
            return params
        case let .myMessage(isComment,user_id, page):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["page"] = page
            params["service"] = isComment ? "Friend.mycomment":"Friend.mymessage"
            return params
        case let .getPushedArticles(user_id, page):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["page"] = page
            params["service"] = "Home.get_article_push"
            return params
        case .uploadImage(_):
            
            return nil
        case let .getMyPost(type, user_id):
            var params: [String: Any] = [:]
            params["type"] = type
            params["user_id"] = user_id
            params["service"] = "User.getMyPost"
            return params
        case let .getMyCollection(user_id, page):
            var params: [String: Any] = [:]
            params["page"] = page
            params["user_id"] = user_id
            params["service"] = "User.getMyCollection"
            return params
        case let .getMyRelationWithItem(item_id, user_id, type):
            var params: [String: Any] = [:]
            params["item_id"] = item_id
            params["user_id"] = user_id
            params["type"] = type
            params["service"] = "Index.getMyRelationWithItem"
            return params
        case let .getHeadInfo(type):
            var params: [String: Any] = [:]
            params["type"] = type
            params["service"] = "Index.getHeadInfo" //物业人事：personnel 民意投票：vote 邻里：user 图片：image 视频：video
            return params

        }
    }
    var sampleData: Data {
        switch self {
        case .login:
            return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
        case .logout:
            return "Create post successfully".data(using: String.Encoding.utf8)!
        default:
            return "Create post successfully".data(using: String.Encoding.utf8)!
        }

    }
    var task: Task{
        switch self {
        case let .uploadAva(_, image, imageName):
            var img: [MultipartFormData] = []
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            let formData = MultipartFormData(provider: .data(imageData!), name: "file", fileName: imageName, mimeType: "image/png")
            img.append(formData)
            
            return .upload(.multipart(img))
        case let .uploadImage(image):
            var img: [MultipartFormData] = []
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            let formData = MultipartFormData(provider: .data(imageData!), name: "file", fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/png")
            img.append(formData)
            
            return .upload(.multipart(img))
        default:
            return .request
        }
        
    }

    var validate: Bool {
        return false
    }
}
