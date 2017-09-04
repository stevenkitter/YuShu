//
//  WXEditMeViewController.swift
//  InternManager
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import ImagePicker
import Lightbox
import SVProgressHUD
class WXEditMeViewController: RootViewController {

    var cells: [[MeCell]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInit()
        setupUI()
        setupRefresh()
        setupNotifi()
    }
    
    override func setupRefresh() {
        tableView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
      
    }
    
    override func loadServerData() {
        super.loadServerData()
        loadUserData()
    }
    
    func loadUserData() {
        guard let userInfo = UserManager.shareUserManager.curUserInfo else{
            self.tableView.mj_header.endRefreshing()
            WXAlertController.alertWithMessageOK(message: "请先登录", okClosure: nil)
            return
        }
        NetworkManager.providerUserApi.request(.userInfo(user_id: userInfo.id ?? ""))
            .mapObject(UserInfo.self)
            .subscribe(onNext: { [unowned self] (userInfo) in
                UserManager.shareUserManager.curUserInfo = userInfo
                self.setupInit()
                self.tableView.mj_header.endRefreshing()
                }, onError: { (error) in
                    self.tableView.mj_header.endRefreshing()
            }).addDisposableTo(disposeBag)
    }

    
    // MARK: -初始化
    func setupInit(){
        guard let user = UserManager.shareUserManager.curUserInfo else{
            return
        }
        cells.removeAll()
        let cell0 = MeCell(imageName: "user_avatar", title: "头像", detail: user.user_avatar ?? "")
        cells.append([cell0])
        
        let cell1 = MeCell(imageName: "nick", title: "昵称", detail: user.user_nickname ?? "")
        let cell2 = MeCell(imageName: "username", title: "真实姓名", detail: user.user_name ?? "")
        let cell3 = MeCell(imageName: "card", title: "身份证", detail: user.user_card ?? "")
        let cell4 = MeCell(imageName: "code", title: "邀请码", detail: user.invitation_code ?? "")
        cells.append([cell1,cell2,cell3,cell4])
        tableView.reloadData()
    }
    
    func setupUI() {
        self.title = "编辑个人信息"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0,0, 0))
        }
        tableView.register(str: "MeInfoTableViewCell")
        tableView.register(str: "MeHeadImageTableViewCell")
    }
    
    func setupNotifi(){
        NotificationCenter.default
            .rx.notification(UserInfoChanged).subscribe(onNext: { [unowned self] (_) in
                self.tableView.mj_header.beginRefreshing()
                }, onError: { (erro) in
                    
            }).addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

  
}

extension WXEditMeViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80:40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellM = cells[indexPath.section][indexPath.row]
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeHeadImageTableViewCell", for: indexPath) as! MeHeadImageTableViewCell
            cell.titleLabel.text = cellM.title
            cell.wxImageView.kfImage(cellM.detail)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeInfoTableViewCell", for: indexPath) as! MeInfoTableViewCell
            cell.titleLabel.text = cellM.title
            cell.wxContentLabel.text = cellM.detail
            if cellM.title == "邀请码" && cellM.detail != ""{
                cell.accessoryType = .none;
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellM = cells[indexPath.section][indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .none {
            return
        }
        if indexPath.section == 0 {
            let imagePickerController = ImagePickerController()
            
            let less = 1;
            imagePickerController.imageLimit = less
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }else{
            let vc = WXEditTextFieldViewController()
            vc.wxNameTitleStr = cellM.imageName
            vc.wxValueStr = cellM.detail
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension WXEditMeViewController: ImagePickerDelegate{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if images.count == 0 {
            return
        }
        let dateDouble = Date().timeIntervalSince1970
        let userId = UserManager.shareUserManager.curUserInfo?.id ?? ""
        let name = "\(Int(dateDouble)).png"
        NetworkManager.providerUserApi.request(.uploadAva(user_id: userId, image: images[0], imageName: name)).mapJSON().subscribe(onNext: { [unowned self] (res) in
            guard let respon = res as? Dictionary<String, Any> else{
                return
            }
            guard let data = respon["data"] as? Dictionary<String, Any> else {
                return
            }
            SVProgressHUD.showSuccess(withStatus: data["msg"] as? String ?? "")
            self.tableView.mj_header.beginRefreshing()
        }, onError: { (err) in
            
        }).addDisposableTo(disposeBag)
       
        
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }

}
