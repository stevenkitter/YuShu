//
//  YSEditMeTextFieldViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import SVProgressHUD

class YSEditMeTextFieldViewController: RootViewController {

    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var ys_titleLabel: UILabel!
    @IBOutlet weak var ys_textField: UITextField!
    
    var notice = ""
    var titleStr = ""
    var text = ""
    var key = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(save))
        noticeLabel.text = notice
        ys_textField.text = text
        ys_titleLabel.text = titleStr
        ys_textField.becomeFirstResponder()
    }
    
    func save() {
        
        guard let text = ys_textField.text else {return}
        if text.realStr().isEmpty {
            SVProgressHUD.showError(withStatus: "不能为空哦")
            return
        }
        changeInfo(str: text)
    }
    
    func changeInfo(str: String) {
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        WXActivityIndicatorView.start()
        NetworkManager.providerUserApi.request(.update(user_id: userId, info: key, value: str))
        .mapJSON().subscribe(onNext: { [unowned self] (res) in
            WXActivityIndicatorView.stop()
            guard let respon = res as? Dictionary<String, Any> else{
                return
            }
            guard let data = respon["data"] as? Dictionary<String, Any> else {
                return
            }
            let msg = data["msg"] as? String
            let code = data["code"] as? Int
            if code == 1 {
                SVProgressHUD.showSuccess(withStatus: msg ?? "修改成功")
                NotificationCenter.default.post(name: UserInfoChanged, object: nil)
                self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: msg ?? "修改失败")
            }
            
            
        }, onError: { (err) in
            
        }).addDisposableTo(disposeBag)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    



}
