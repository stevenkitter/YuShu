//
//  RootViewController+Ex.swift
//  InternManager
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import UIKit
extension RootViewController {
    func setupNavi(color: UIColor) {
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.setBackgroundImage(color.createImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setClearNavi() -> Void {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    func showLogin()-> Bool {
        if UserManager.shareUserManager.curUserInfo != nil {
            return true
        }
        let loginVc = LoginViewController()
        self.present(loginVc, animated: true, completion: nil)
        return false
    }
    
    func showLoginWithClosure(closure: @escaping ()->Void)-> Bool {
        if UserManager.shareUserManager.curUserInfo != nil {
            return true
        }
        let loginVc = LoginViewController()
        loginVc.closure = closure
        self.present(loginVc, animated: true, completion: nil)
        return false
    }
    
    func dismissPresent() {
        var presentVc = self.presentingViewController
        while presentVc?.presentingViewController != nil {
            presentVc = presentVc?.presentingViewController
        }
        presentVc?.dismiss(animated: true, completion: nil)
    }
}
//MARK: -红点
extension RootViewController {
    func redCount(closure: ((_ model: UnRead)->Void)?){
        guard let user = UserManager.shareUserManager.curUserInfo else{
            return
        }
        NetworkManager.providerUserApi.request(.unRead(user_id: user.id ?? "")).mapObject(UnRead.self).subscribe(onNext: { (unReadModel) in
            closure?(unReadModel)
        }, onError: { (err) in
            
        }).addDisposableTo(disposeBag)
    }
}
