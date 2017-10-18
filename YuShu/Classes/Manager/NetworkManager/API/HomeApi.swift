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
    case getImagesByPackageId(image_package_id: String)
    case getVideoList()
    case getAnnounceList(user_id: String, page: Int,type: Int) //1:群主公告 2：民政汇总
    case getPersons()
    case getVoteList(user_id: String, page: Int)
    case getVoteInfo(vote_id: String, user_id: String)
    case doVote(user_id: String, vote_id: String,vote_option_id: String)
    case getCommentList(user_id: String, type: String, item_id: String, page: Int)
    case getPraiseList(user_id: String, type: String, item_id: String)
    case doPraise(user_id: String, praise_type: String, praise_item_id: String, cancle: Int) //装修指南-guide,民意投票-vote,闲置转让-transfer,御墅论坛-post
    
    case doComment(user_id: String, comment_type: String, comment_item_id: String, comment_desc: String)//其中comment_type:装修指南-guide,民意投票-vote,闲置转让-transfer,御墅论坛-post
    
    case getTransferList(page: Int)
    case doTransfer(user_id: String, transfer_title: String, transfer_desc: String, transfer_type: String,images: [UIImage]) //1:馈赠2：置换
    case fitmentTags(category: Int) //1:辅材商店 2：装修配套
    case fitmentList(page: Int, guide_type_id: String)
    case doCollection(user_id: String, collection_type: String, collection_item_id: String, cancle: Int)
    case deleteMyDo(type: String, item_id: String)
    case postInfo(page: Int, post_type: String) //1:最新动态2：公共建议
    case doPost(post_title: String, post_desc: String, post_type: String, user_id: String, images: [UIImage])
    
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
        case .doTransfer:
            return ServiceUrlStr + "?service=Index.doTransfer"
        case .doPost:
            return ServiceUrlStr + "?service=Index.doPost"
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
        case .doTransfer:
            return .post
        case .doPost:
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
        case .homeInfo():
            var params: [String: Any] = [:]
            params["service"] = "Index.getIndexInfo"
            return params
        case .getImageList():
            var params: [String: Any] = [:]
            params["service"] = "Index.getAllImagepackages"
            
            return params
        case let .getImagesByPackageId(image_package_id):
            var params: [String: Any] = [:]
            params["image_package_id"] = image_package_id
            params["service"] = "Index.getImagesByImagepackage"
            
            return params
        case .getVideoList():
            var params: [String: Any] = [:]
            params["service"] = "Index.getAllVideos"
            return params
            
        case let .getAnnounceList(user_id, page, type):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["page"] = page
            params["type"] = type
            params["service"] = "Index.getAdminnoticeInfo"
            return params
        case .getPersons():
            var params: [String: Any] = [:]
            params["service"] = "Index.getpersonnelInfo"
            return params
        case let .getVoteList(user_id, page):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["page"] = page
            params["service"] = "Index.getVoteInfo"
            return params
        case let .getVoteInfo(vote_id, user_id):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["vote_id"] = vote_id
            params["service"] = "Index.getVoteInfoById"
            return params
        case let .doVote(user_id, vote_id,vote_option_id):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["vote_id"] = vote_id
            params["vote_option_id"] = vote_option_id
            params["service"] = "Index.doVote"
            return params
        case let .getCommentList(user_id, type, item_id, page):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["type"] = type
            params["item_id"] = item_id
            params["page"] = page
            params["service"] = "Index.getCommentList"
            return params
        case let .doPraise(user_id, praise_type, praise_item_id, cancle):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["praise_type"] = praise_type
            params["praise_item_id"] = praise_item_id
            params["cancle"] = cancle
            params["service"] = "Index.doPraise"
            return params
        case let .getPraiseList(user_id, type, item_id):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["type"] = type
            params["item_id"] = item_id
            params["service"] = "Index.getPraiseList"
            return params
            
        case let .doComment(user_id, comment_type, comment_item_id, comment_desc):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["comment_type"] = comment_type
            params["comment_item_id"] = comment_item_id
            params["comment_desc"] = comment_desc
            params["service"] = "Index.doComment"
            return params
        case let .getTransferList(page):
            var params: [String: Any] = [:]
            params["page"] = page
            params["service"] = "Index.getTransferInfo"
            return params
        case let .doTransfer(user_id, transfer_title, transfer_desc, transfer_type,_):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["transfer_title"] = transfer_title
            params["transfer_desc"] = transfer_desc
            params["transfer_type"] = transfer_type
            return params
        case let .fitmentTags(category):
            var params: [String: Any] = [:]
            params["category"] = category
            params["service"] = "Index.getGuideTypeInfo"
            return params
        case let .fitmentList(page, guide_type_id):
            var params: [String: Any] = [:]
            params["page"] = page
            params["guide_type_id"] = guide_type_id
            params["service"] = "Index.getGuideInfo"
            return params
        case let .doCollection(user_id, collection_type, collection_item_id, cancle):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["collection_type"] = collection_type
            params["collection_item_id"] = collection_item_id
            params["cancle"] = cancle
            params["service"] = "Index.doCollection"
            return params
        case let .deleteMyDo(type, item_id):
            var params: [String: Any] = [:]
            params["type"] = type
            params["item_id"] = item_id
            params["service"] = "Index.deleteMyDo"
            return params
        case let .postInfo(page, post_type):
            var params: [String: Any] = [:]
            params["page"] = page
            params["post_type"] = post_type
            params["service"] = "Index.getPostInfo"
            return params
        case let .doPost(post_title, post_desc, post_type, user_id, _):
            var params: [String: Any] = [:]
            params["post_title"] = post_title
            params["post_desc"] = post_desc
            params["post_type"] = post_type
            params["user_id"] = user_id
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
        switch self {
        case let .doTransfer(_,_, _, _,images):
            var postImg: [MultipartFormData] = []
            for (_,item) in images.enumerated() {
                let imageData = UIImageJPEGRepresentation(item, 0.5)
                let name = Int(Date().timeIntervalSince1970 * 1000)
                let formData = MultipartFormData(provider: .data(imageData!), name: "filelist[]", fileName: "\(name).png", mimeType: "image/png")
                postImg.append(formData)
            }
            return .upload(.multipart(postImg))
            
        case let .doPost(_, _, _, _,images):
            var postImg: [MultipartFormData] = []
            for (_,item) in images.enumerated() {
                let imageData = UIImageJPEGRepresentation(item, 0.5)
                let name = Int(Date().timeIntervalSince1970 * 1000)
                let formData = MultipartFormData(provider: .data(imageData!), name: "filelist[]", fileName: "\(name).png", mimeType: "image/png")
                postImg.append(formData)
            }
            return .upload(.multipart(postImg))
        default:
            return .request
        }
        
    }
    
    var validate: Bool {
        return false
    }

}
