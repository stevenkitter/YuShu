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
    case login(tel:String, password: String)
    case logout
    case userInfo(user_id: String)
    case update(tel: String, info: String, value: String)
    case register(tel: String, pass: String)
    case getCode(tel: String)
    case updateByUserId(user_id: String, info: String, value: String)
    case uploadAva(user_id: String, image: UIImage, imageName: String)
    case getCollects(user_id: String, page: Int)
    case unRead(user_id: String)
    case myMessage(isComment: Bool,user_id: String, page: Int)
    case getPushedArticles(user_id: String, page: Int)
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
        default:
            return .get
        }
    }
    var parameterEncoding: ParameterEncoding{
        return URLEncoding.default
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .login(tel,password):
            var params: [String: Any] = [:]
            params["tel"] = tel
            params["pass"] = password
            params["service"] = "User.login"
            return params
        case .logout:
            return nil
        case let .userInfo(user_id):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["service"] = "User.get_user"
            return params
        case let .register(tel, pass):
            var params: [String: Any] = [:]
            params["tel"] = tel
            params["pass"] = pass
            params["service"] = "User.register"
            return params
        case let .update(tel, info, value):
            var params: [String: Any] = [:]
            params["tel"] = tel
            params[info] = value
            params["service"] = "User.update_user"
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
            
        default:
            return .request
        }
        
    }

    var validate: Bool {
        return false
    }
}
