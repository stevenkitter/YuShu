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
    case getArticle(page: Int)
    case getAd(classid: Int)
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
        case .getArticle:
            return ServiceUrlStr
        case .getAd:
            return ServiceUrlStr
        default:
            return ServiceUrlStr
        }
    }
    var method: Moya.Method {
        switch self {
        case .getArticle:
            return .get
        case .getAd:
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
        case let .getArticle(page):
            var params: [String: Any] = [:]
            params["page"] = page
            params["service"] = "Home.get_article"
            return params
        case let .getAd(classid):
            var params: [String: Any] = [:]
            params["classid"] = classid
            params["service"] = "Home.ad"
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
