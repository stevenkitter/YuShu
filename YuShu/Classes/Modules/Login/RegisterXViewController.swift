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
    
    @IBOutlet weak var getCodeBtn: UIButton!
    
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
        let _ = usernameTextField.rx.text.orEmpty
            .map {$0.characters.count >= minUsernameLength && $0.characters.count < maxUsernameLength}.subscribe(onNext: { [unowned self] (isable) in
                self.getCodeBtn.isEnabled = isable
            }, onError: { (error) in
                
            }).addDisposableTo(disposeBag)
        getCodeBtn.rx.tap.subscribe(onNext: { [unowned self] in
            self.getCode()
        }).addDisposableTo(disposeBag)
        
        let usernameValid = usernameTextField.rx.text.orEmpty
            .map {$0.characters.count >= minUsernameLength && $0.characters.count < maxUsernameLength}
        let codeValid = codeTextField.rx.text.orEmpty
            .map {$0.characters.count >= 4}
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map {$0.characters.count >= minPasswordLength && $0.characters.count < maxPasswordLength}
        let passwordSureValid = passwordSureTextField.rx.text.orEmpty
            .map {$0.characters.count >= minPasswordLength && $0.characters.count < maxPasswordLength}
        Observable.combineLatest(usernameValid, codeValid, passwordValid, passwordSureValid)
            .map({ $0 && $1 && $2 && $3})
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
    fileprivate func getCode(){
        WXActivityIndicatorView.start()
        NetworkManager.providerUserApi.request(.getCode(tel: usernameTextField.text ?? "")).mapJSON()
        .subscribe(onNext: { (res) in
            WXActivityIndicatorView.stop()
            guard let respon = res as? Dictionary<String, Any> else{
                return
            }
            guard let data = respon["data"] as? Dictionary<String, Any> else {
                return
            }
            guard let result = data["data"] as? Dictionary<String, Any> else {
                return
            }
            SVProgressHUD.showSuccess(withStatus: data["msg"] as? String ?? "")
            self.code = "\(result["captcha"] ?? "")"
            self.codeXGeted()
            
        }, onError: { (er) in
            WXActivityIndicatorView.stop()
        }).addDisposableTo(disposeBag)
    }
    
    fileprivate func register() {
        if passwordTextField.text != passwordSureTextField.text {
            SVProgressHUD.showError(withStatus: "两次密码输入不一样")
            return
        }
        if codeTextField.text != code {
            SVProgressHUD.showError(withStatus: "验证码错误")
            return
        }
        WXActivityIndicatorView.start()
        if !isFindPassword {
            NetworkManager.providerUserApi.request(.register(tel: usernameTextField.text ?? "", pass: passwordTextField.text ?? "")).mapJSON()
                .subscribe(onNext: { [unowned self] (res) in
                WXActivityIndicatorView.stop()
                guard let respon = res as? Dictionary<String, Any> else{
                    return
                }
                guard let data = respon["data"] as? Dictionary<String, Any> else {
                    return
                }
                SVProgressHUD.showSuccess(withStatus: "注册成功请登录")
                self.dismissPresent()
                
                
            }, onError: { (error) in
                WXActivityIndicatorView.stop()
            }).addDisposableTo(disposeBag)
        }else{
            NetworkManager.providerUserApi.request(.update(tel: usernameTextField.text ?? "", info: "pass", value: passwordTextField.text ?? "")).mapJSON()
                .subscribe(onNext: { [unowned self] (res) in
                    WXActivityIndicatorView.stop()
                    guard let respon = res as? Dictionary<String, Any> else{
                        return
                    }
                    guard let data = respon["data"] as? Dictionary<String, Any> else {
                        return
                    }
                    SVProgressHUD.showSuccess(withStatus: "修改成功，请登录")
                    self.dismiss(animated: true, completion: nil)
                    
                    
                    }, onError: { (error) in
                    WXActivityIndicatorView.stop()
                }).addDisposableTo(disposeBag)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

   

}

extension RegisterXViewController {
    func codeXGeted(){
        var second = 60
        
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        let work = DispatchWorkItem {
            
            DispatchQueue.main.async {
                self.getCodeBtn.isEnabled = false
                self.getCodeBtn.setTitle("剩余\(second)", for: .disabled)
            }
            if second == 0 {
                DispatchQueue.main.async {
                    self.getCodeBtn.isEnabled = true
                }
                timer.cancel()
            }
            second -= 1
        }
        
        
        
        timer.scheduleRepeating(deadline: .now(), interval: .seconds(1), leeway: .seconds(60))
        timer.setEventHandler(handler: work)
        if #available(iOS 10.0, *) {
            timer.activate()
        } else {
            
            timer.resume()
        }
    }
}
