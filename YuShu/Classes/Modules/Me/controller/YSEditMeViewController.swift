//
//  YSEditMeViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import ImagePicker
import SVProgressHUD
import Lightbox
import ActionSheetPicker_3_0
class YSEditMeViewController: RootViewController {
    
    var contents: [YSMeHeadViewCellM] = []
    

    @IBAction func logout(_ sender: UIButton) {
        UserManager.shareUserManager.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCellM()
        setupNoti()
    }
    
    func setupUI() {
        self.title = "个人资料"
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 50, 0))
        }
        tableView.register(str: "YSEditMeImageTableViewCell")
        tableView.register(str: "YSEditMeTableViewCell")
    }
    
    func setupCellM() {
        contents.removeAll()
        
        guard let user = UserManager.shareUserManager.curUserInfo else {return}
        
        let icon = YSMeHeadViewCellM(image: "", title: "头像", num: user.user_headpic ?? "")
        contents.append(icon)
        
        let nick = YSMeHeadViewCellM(image: "", title: "昵称", num: user.user_nickname ?? "")
        contents.append(nick)
        
        let name = YSMeHeadViewCellM(image: "", title: "真实姓名", num: user.user_name ?? "")
        contents.append(name)
        
        let sex = YSMeHeadViewCellM(image: "", title: "性别", num: (user.user_sex ?? "").sex())
        contents.append(sex)
        
        let tel = YSMeHeadViewCellM(image: "", title: "手机", num: user.user_tel ?? "")
        contents.append(tel)
        
        let birth = YSMeHeadViewCellM(image: "", title: "出生年月", num: (user.user_birthday ?? "").timeStr())
        contents.append(birth)
        
        let privacy = YSMeHeadViewCellM(image: "", title: "隐私设置", num: "")
        contents.append(privacy)
        
        tableView.reloadData()
    }
    
    func setupNoti() {
        NotificationCenter.default.rx.notification(UserInfoChanged).subscribe(onNext: { [unowned self] (_) in
            self.loadUserInfo(ok: { [unowned self] in
                self.setupCellM()
            })
            
            }, onError: { (err) in
                
        }).addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

 

}

extension YSEditMeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = contents[indexPath.row]
        switch model.title {
        case "头像":
            return 70
        default:
            return 50
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = contents[indexPath.row]
        switch model.title {
        case "头像":
            let cell = tableView.dequeueReusableCell(withIdentifier: "YSEditMeImageTableViewCell", for: indexPath) as! YSEditMeImageTableViewCell
            cell.ys_titleLabel.text = model.title
            cell.ys_imageView.kfImage(model.num)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YSEditMeTableViewCell", for: indexPath) as! YSEditMeTableViewCell
            cell.ys_titleLabel.text = model.title
            cell.detailLabel.text = model.num
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = contents[indexPath.row]
        switch model.title {
        case "头像":
            selectIcon()
        case "昵称":
            changeInfo(str: model.title)
        case "真实姓名":
            changeInfo(str: model.title)
        case "性别":
            selectSex()
        case "手机":
            changeInfo(str: model.title)
        case "出生年月":
            selectDate()
        case "隐私设置":
            privacySetting()
        default:
            return
        }
    }
}
extension YSEditMeViewController{
    func selectIcon() {
        let imagePicker = ImagePickerController()
        imagePicker.imageLimit = 1
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)

    }
    
    func changeInfo(str: String) {
        guard let user = UserManager.shareUserManager.curUserInfo else {return}
        
        let vc = YSEditMeTextFieldViewController()
        switch str {
        case "昵称":
            vc.notice = "昵称请尽量输入汉字、字母、数字或者下划线"
            vc.text = user.user_nickname ?? ""
            vc.titleStr = "新\(str)"
            vc.key = "user_nickname"
        case "真实姓名":
            vc.notice = "您的真实姓名，方便大家熟悉您"
            vc.text = user.user_name ?? ""
            vc.titleStr = "新\(str)"
            vc.key = "user_name"
        case "手机":
            vc.notice = "请输入您有效的电话号码，方便联系您"
            vc.text = user.user_tel ?? ""
            vc.titleStr = "新\(str)"
            vc.key = "user_tel"
        default:
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func selectSex() {
        guard let user = UserManager.shareUserManager.curUserInfo else {return}
        let rows = ["男","女","保密"]
        let selectedStr = (user.user_sex ?? "").sex()
        let index = rows.index(of: selectedStr)
        ActionSheetStringPicker.show(withTitle: "性别", rows: rows, initialSelection: index ?? 0, doneBlock: { [unowned self] (picker, inde, value) in
            self.changeInfo(key: "user_sex", str: "\(inde + 1)")
        }, cancel: { (_) in
            
        }, origin: self.view)
    }
    func selectDate() {
        
        guard let user = UserManager.shareUserManager.curUserInfo else {return}
        let selectedDate = (user.user_birthday ?? "").strDate()
        let datePicker = ActionSheetDatePicker(title: "生日年月", datePickerMode: .date, selectedDate: selectedDate, doneBlock: { [unowned self]
            picker, value, index in
            guard let time = value as? Date else {return}
            let inter = time.timeIntervalSince1970
            self.changeInfo(key: "user_birthday", str: "\(Int(inter))")
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: self.view)
        
        datePicker?.show()
    }
    
    
    func privacySetting() {
        let vc = YSEditPrivacySettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension YSEditMeViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else {return}
        let lightImages = images.map{return LightboxImage(image: $0)}
        let box = LightboxController(images: lightImages, startIndex: 0)
        imagePicker.present(box, animated: true, completion: nil)
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count == 1 else {return}
        WXActivityIndicatorView.start()
        NetworkManager.providerUserApi.request(.uploadImage(image: images.first!)).mapJSON().subscribe(onNext: { [unowned self] (res) in
            WXActivityIndicatorView.stop()
            guard let respon = res as? Dictionary<String, Any> else{
                return
            }
            guard let data = respon["data"] as? Dictionary<String, Any> else {
                return
            }
            let msg = data["msg"] as? String
            let code = data["code"] as? Int
            let url = data["url"] as? String
            if code == 1 {
                
                self.changeInfo(key: "user_headpic", str: url ?? "")
                
            }else{
                SVProgressHUD.showError(withStatus: msg ?? "图片上传失败")
            }
            
        }, onError: { (err) in
            
        }).addDisposableTo(self.disposeBag)

        imagePicker.dismiss(animated: true, completion: nil)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
