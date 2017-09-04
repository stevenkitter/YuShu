//
//  Observable+ObjectMapper.swift
//
//  Created by Ivan Bruel on 09/12/15.
//  Copyright © 2015 Ivan Bruel. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
public extension Response {
//    public func mapStatus<T: BaseMappable>(_ )
    
    
  /// Maps data received from the signal into an object which implements the Mappable protocol.
  /// If the conversion fails, the signal errors.
	public func mapObject<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) throws -> T {
        
        guard let json = try? JSONSerialization.jsonObject(with: self.data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any] else {
            let msg = NSLocalizedString("error.api", comment: "")
            WXAlertController.alertWithMessageOK(message: msg, okClosure: nil)
            throw MoyaError.jsonMapping(self)
        }
        
        guard let jsonData = json["data"] as? [String: Any] else {
            throw MoyaError.jsonMapping(self)
        }
        
        guard let status = jsonData["status"] as? String else {
            throw MoyaError.jsonMapping(self)
        }
        
        if status != "ok" {
            let msg = jsonData["msg"] ?? NSLocalizedString("error.api", comment: "")
            WXAlertController.alertWithMessageOK(message: msg as! String, okClosure: nil)
            throw MoyaError.jsonMapping(self)
        }
        
		guard let object = Mapper<T>(context: context).map(JSONObject: jsonData["data"]) else {
            throw MoyaError.jsonMapping(self)
            }
        return object
    }

  /// Maps data received from the signal into an array of objects which implement the Mappable
  /// protocol.
  /// If the conversion fails, the signal errors.
  public func mapArray<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) throws -> [T] {
    guard let json = try? JSONSerialization.jsonObject(with: self.data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any] else {
        let msg = "服务器数据错误"
        WXAlertController.alertWithMessageOK(message: msg, okClosure: nil)
        throw MoyaError.jsonMapping(self)
    }
    
    guard let jsonData = json["data"] as? [String: Any] else {
        throw MoyaError.jsonMapping(self)
    }
    
    guard let status = jsonData["status"] as? String else {
        throw MoyaError.jsonMapping(self)
    }
    
    if status != "ok" {
        let msg = jsonData["msg"] ?? "获取数据失败"
        WXAlertController.alertWithMessageOK(message: msg as! String, okClosure: nil)
        throw MoyaError.jsonMapping(self)
    }
    
	guard let array = jsonData["data"] as? [[String : Any]] else {
      throw MoyaError.jsonMapping(self)
    }
    return Mapper<T>(context: context).mapArray(JSONArray: array)
  }

}


// MARK: - ImmutableMappable

public extension Response {

  /// Maps data received from the signal into an object which implements the ImmutableMappable
  /// protocol.
  /// If the conversion fails, the signal errors.
  public func mapObject<T: ImmutableMappable>(_ type: T.Type, context: MapContext? = nil) throws -> T {
    
	return try Mapper<T>(context: context).map(JSONObject: try mapJSON())
  }

  /// Maps data received from the signal into an array of objects which implement the ImmutableMappable
  /// protocol.
  /// If the conversion fails, the signal errors.
  public func mapArray<T: ImmutableMappable>(_ type: T.Type, context: MapContext? = nil) throws -> [T] {
    guard let array = try mapJSON() as? [[String : Any]] else {
      throw MoyaError.jsonMapping(self)
    }
	return try Mapper<T>(context: context).mapArray(JSONArray: array)
  }

}
