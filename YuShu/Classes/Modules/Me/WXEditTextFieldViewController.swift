//
//  WXEditTextFieldViewController.swift
//  InternManager
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import SVProgressHUD
class WXEditTextFieldViewController: RootViewController {
    var wxValueStr: String = ""
    var wxNameTitleStr: String = ""
    let textF = UITextField().then {
        $0.backgroundColor = UIColor.white
        $0.borderStyle = .roundedRect
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInit()
    }
    func setupUI(){
        self.view.addSubview(self.textF)
        textF.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(64+15)
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.height.equalTo(50)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }
    func setupInit(){
        textF.text = wxValueStr
    }
    func save(){
        if textF.text?.realStr() == "" {
            SVProgressHUD.showError(withStatus: "请填写完整")
            return
        }
        let userId = UserManager.shareUserManager.curUserInfo?.id ?? ""
        WXActivityIndicatorView.start()
        NetworkManager.providerUserApi.request(.updateByUserId(user_id: userId, info: wxNameTitleStr, value: textF.text ?? "")).mapJSON()
        .subscribe(onNext: { (res) in
            WXActivityIndicatorView.stop()
            guard let respon = res as? Dictionary<String, Any> else{
                return
            }
            guard let data = respon["data"] as? Dictionary<String, Any> else {
                return
            }
            SVProgressHUD.showSuccess(withStatus: data["msg"] as? String ?? "")
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: UserInfoChanged, object: nil)
            
        }, onError: { (err) in
            
        }).addDisposableTo(disposeBag)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
