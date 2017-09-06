//
//  LoginViewController.swift
//  InternManager
//
//  Created by apple on 2017/8/3.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper
import Moya
import CryptoSwift
import SVProgressHUD


let minUsernameLength = 11
let maxUsernameLength = 20

let minPasswordLength = 6
let maxPasswordLength = 20
class LoginViewController: RootViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
  
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var usernameView: UIView!
    
    
    var closure: (()->Void)?
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setupUI() {
        userNameTextField.leftViewWithImageName(imageName: "account")
        passwordTextField.leftViewWithImageName(imageName: "password")
    }
    func setupRx() {
        let usernameValid = userNameTextField.rx.text.orEmpty
            .map {$0.characters.count >= 3 }
//        let _ = userNameTextField.rx.text.orEmpty
//            .map {$0.characters.count >= minUsernameLength && $0.characters.count < maxUsernameLength}
//            .subscribe(onNext: { [unowned self] (flag) in
//                self.usernameView.backgroundColor = flag ? #colorLiteral(red: 0.2182945311, green: 0.6282978058, blue: 0.5143177509, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            }).addDisposableTo(disposeBag)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map {$0.characters.count >= minPasswordLength && $0.characters.count < maxPasswordLength}
//        let _ = passwordTextField.rx.text.orEmpty
//            .map {$0.characters.count >= minPasswordLength && $0.characters.count < maxPasswordLength}
//            .subscribe(onNext: { [unowned self] (flag) in
//                self.passwordView.backgroundColor = flag ? #colorLiteral(red: 0.2182945311, green: 0.6282978058, blue: 0.5143177509, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            }).addDisposableTo(disposeBag)
        
        
        Observable.combineLatest(usernameValid, passwordValid)
            .map({ $0 && $1 })  //当两者都处于可用状态时登录按钮方为可用
            .subscribe(onNext:{
                self.loginButton.isEnabled = $0
                self.loginButton.backgroundColor = $0 ? #colorLiteral(red: 0.2182945311, green: 0.6282978058, blue: 0.5143177509, alpha: 1) : UIColor.lightGray
                self.loginButton.setTitleColor(($0 ? UIColor.white : UIColor.darkGray), for: .normal)
            })
            .addDisposableTo(disposeBag)
    }
    /// 界面按钮的几个交互事件
    ///
    /// - Parameter sender: tag 0登录 1注册 2看看 3关闭 4登录遇到问题
    @IBAction func userClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            login()
        case 1:
            goRegister()
        case 2:
            self.dismissPresent()
        case 3:
            self.dismiss(animated: true, completion: nil)
        case 4:
            findPassword()
        default:
            break
        }
    }
    func goRegister() {
        let vc = RegisterXViewController()
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true, completion: nil)
    }
    func findPassword() {
        
        let vc = RegisterXViewController()
        vc.isFindPassword = true
        vc.modalTransitionStyle = .flipHorizontal
        self.present(vc, animated: true, completion: nil)
    }
    
    func login(){
       
        WXActivityIndicatorView.start()
        NetworkManager.providerUserApi.request(.login(account: userNameTextField.text ?? "", pwd: passwordTextField.text ?? ""))
            .mapObject(UserInfo.self)
            .subscribe(onNext: { (userInfo) in
                WXActivityIndicatorView.stop()
                UserManager.shareUserManager.curUserInfo = userInfo
                SVProgressHUD.showSuccess(withStatus: "登录成功")
                NotificationCenter.default.post(name: NotificationLoginStateChange, object: true)
                
                
                
            }, onError: { (error) in
                WXActivityIndicatorView.stop()
            }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
    }
    
}

extension LoginViewController {
    //tool
    func md5s(str: String)-> String{
        let subStr = "###"
        let newStr = "DkF9Z6HGpfbkyFJtz4\(str)".md5().md5()
        return subStr + newStr
    }
}








