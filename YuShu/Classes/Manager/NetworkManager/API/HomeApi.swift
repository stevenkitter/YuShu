//
//  HomeApi.swift
//  InternManager
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import Moya

enum HomeApi {
    case homeInfo()
    case getImageList()
    case getVideoList()
    case getComment(article_id: String, user_id: String, page: Int)
    case isCollect(article_id: String, user_id: String)
    case setCollect(article_id: String, user_id: String)
    case sendCommentArticle(user_id: String, article_id: String, content: String)
    case sendCommentComment(user_id: String, article_id: String, content: String, comment_id: String)
}

extension HomeApi: TargetType {
    var baseURL: URL {
        return URL(string: BaseUrlStr)!
    }
    
    var path: String {
        switch self {
        case .getImageList:
            return ServiceUrlStr
        case .getVideoList:
            return ServiceUrlStr
        default:
            return ServiceUrlStr
        }
    }
    var method: Moya.Method {
        switch self {
        case .getImageList:
            return .get
        case .getVideoList:
            return .get
        default:
            return .get
        }
    }
    var parameterEncoding: ParameterEncoding{
        return URLEncoding.default
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .homeInfo():
            var params: [String: Any] = [:]
            params["service"] = "Index.getIndexInfo"
            return params
        case .getImageList():
            var params: [String: Any] = [:]
            params["service"] = "Index.getAllImages"
            return params
        case .getVideoList():
            var params: [String: Any] = [:]
            params["service"] = "Index.getAllVideos"
            return params
        case let .getComment(article_id, user_id, page):
            var params: [String: Any] = [:]
            params["article_id"] = article_id
            params["user_id"] = user_id
            params["page"] = page
            params["service"] = "User.get_comment"
            return params
        case let .isCollect(article_id, user_id):
            var params: [String: Any] = [:]
            params["article_id"] = article_id
            params["user_id"] = user_id
            params["service"] = "User.iscollect"
            return params
        case let .setCollect(article_id, user_id):
            var params: [String: Any] = [:]
            params["article_id"] = article_id
            params["user_id"] = user_id
            params["service"] = "User.setcollect"
            return params
        case let .sendCommentArticle(user_id, article_id, content):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["article_id"] = article_id
            params["content"] = content
            params["service"] = "User.send_comment"
            return params
        case let .sendCommentComment(user_id, article_id, content, comment_id):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["article_id"] = article_id
            params["content"] = content
            params["comment_id"] = comment_id
            params["service"] = "User.send_comment"
            return params
        }
    }
    var sampleData: Data {
       
        return "Create post successfully".data(using: String.Encoding.utf8)!
        
        
    }
    var task: Task{
        return .request
    }
    
    var validate: Bool {
        return false
    }

}
