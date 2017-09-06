//
//  RegisterXViewController.swift
//  InternManager
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
class RegisterXViewController: RootViewController {
    
    /// 是否是找回密码页面
    var isFindPassword = false
    var code = ""
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var passwordSureTextField: UITextField!
    
   
    
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }

    
    /// 点击事件
    ///
    /// - Parameter sender: 0 1 2 叉 去登录页面 随便看看
    @IBAction func clickedAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.dismiss(animated: true, completion: nil)
        case 1:
            self.dismiss(animated: true, completion: nil)
        case 2:
            self.dismissPresent()
        default:
            break
        }
    }
    
    func setupUI() {
        usernameTextField.leftViewWithImageName(imageName: "phoneicon")
        codeTextField.leftViewWithImageName(imageName: "codeNum")
        passwordTextField.leftViewWithImageName(imageName: "passwordicon")
        passwordSureTextField.leftViewWithImageName(imageName: "passwordSure")
        isFindPassword ? actionButton.setTitle("重置密码", for: .normal) : actionButton.setTitle("注册", for: .normal)
        
    }
    
    func setupRx() {
       
       
        //楼号
        let usernameValid = usernameTextField.rx.text.orEmpty
            .map { (str) -> Bool in
                if !str.characters.contains("#") {
                    return false
                }
                let twoStrs = str.components(separatedBy: "#")
                if twoStrs.count != 2 {
                    return false
                }
                for item in twoStrs {
                    if item.characters.count == 0 {
                        return false
                    }
                }
                return true
        }
        //手机号
        let codeValid = codeTextField.rx.text.orEmpty
            .map {$0.isRealPhoneNumber()}
        
        //名字
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map {$0.characters.count >= 1}
        
        
        Observable.combineLatest(usernameValid, codeValid, passwordValid)
            .map({ $0 && $1 && $2})
            .subscribe(onNext:{ [unowned self] in
                self.actionButton.isEnabled = $0
                self.actionButton.backgroundColor = $0 ? #colorLiteral(red: 0.2182945311, green: 0.6282978058, blue: 0.5143177509, alpha: 1) : UIColor.lightGray
                self.actionButton.setTitleColor(($0 ? UIColor.white : UIColor.darkGray), for: .normal)
            })
            .addDisposableTo(disposeBag)
        actionButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.register()
        }).addDisposableTo(disposeBag)
    }
    
    
    fileprivate func register() {
        WXActivityIndicatorView.start()
        
        guard let twoStrs = usernameTextField.text?.components(separatedBy: "#") else {return}
        NetworkManager.providerUserApi.request(.register(user_name: passwordTextField.text ?? "", user_floor: twoStrs.first ?? "", user_room:  twoStrs.last ?? "", user_tel: codeTextField.text ?? "")).mapJSON()
            .subscribe(onNext: { [unowned self] (res) in
            WXActivityIndicatorView.stop()
            guard let respon = res as? Dictionary<String, Any> else{
                return
            }
            guard let data = respon["data"] as? Dictionary<String, Any> else {
                return
            }
                
            let msg = data["msg"] as? String
            let code = data["code"] as? Int
            self.alertWithMessageOK(message: msg ?? "成功", okClosure: { [unowned self] (_) in
                if code == 1 {
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
            
            
            
        }, onError: { (error) in
            WXActivityIndicatorView.stop()
        }).addDisposableTo(disposeBag)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

   

}

extension RegisterXViewController {
    
}
