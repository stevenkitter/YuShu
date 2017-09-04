//
//  WXAlertController.swift
//  InternManager
//
//  Created by apple on 2017/8/12.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
class WXAlertController {
    static func alertWithMessageOKCancel(message: String, okClosure: ((_ alertAction: UIAlertAction) -> Void)?, cancelClosure: ((_ alertAction: UIAlertAction) -> Void)?){
        
        let alertC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .destructive, handler: okClosure)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: cancelClosure)
        alertC.addAction(okAction)
        alertC.addAction(cancelAction)
        
        RootController?.present(alertC, animated: true, completion: nil)
    }
    
    static func alertWithMessageOK(message: String, okClosure: ((_ alertAction: UIAlertAction) -> Void)?){
        
        let alertC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .destructive, handler: okClosure)
        alertC.addAction(okAction)
        RootController?.present(alertC, animated: true, completion: nil)
    }
    
    static func actionWithMessageOKCancel(message: String, okClosure: ((_ alertAction: UIAlertAction) -> Void)?, cancelClosure: ((_ alertAction: UIAlertAction) -> Void)?){
        
        let alertC = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "确定", style: .destructive, handler: okClosure)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: cancelClosure)
        alertC.addAction(okAction)
        alertC.addAction(cancelAction)
        
        RootController?.present(alertC, animated: true, completion: nil)
    }
}
