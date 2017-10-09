//
//  YSTransferAddViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/15.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import SVProgressHUD
class YSTransferAddViewController: RootViewController {

    let footContainer = UIView()
    let footBtn = UIButton.buttonWithTitle(normal: "发布", disable: "完整信息")
    var type = "2"
    
    var postWhat = 0 // 0 1 2 最新 闲置 公共
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        setupUI()
    }
    
    func setupUI() {
        tableViewGrouped.delegate = self
        tableViewGrouped.dataSource = self
        
        self.view.addSubview(self.tableViewGrouped)
        tableViewGrouped.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 50, 0))
        }
        tableViewGrouped.register(str: "AddImageTableViewCell")
        tableViewGrouped.register(str: "YSAddTextTableViewCell")
        tableViewGrouped.register(str: "YSEditMeTableViewCell")
        tableViewGrouped.backgroundColor = UIColor.groupTableViewBackground
        tableViewGrouped.separatorStyle = .none
        
        let bar = UINavigationBar(frame: CGRect.zero)
        bar.barTintColor = KNaviColor
        bar.tintColor = KTintColor
        bar.titleTextAttributes = [NSForegroundColorAttributeName:KTintColor]
        bar.setBackgroundImage(KNaviColor.createImage(), for: .default)
        
        let item = UINavigationItem(title: "发布信息")
        bar.pushItem(item, animated: true)
        item.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        
        view.addSubview(bar)
        bar.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(0)
            make.bottom.equalTo(self.tableViewGrouped.snp.top)
        }
        
        footContainer.addSubview(footBtn)
        footBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(footContainer).inset(UIEdgeInsetsMake(5, 10, 5, 10))
        }
        view.addSubview(footContainer)
        
        footContainer.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(50)
        }
        
        footBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)

    }

    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func submit() {
        let cell0 = tableViewGrouped.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddImageTableViewCell
        let cell1 = tableViewGrouped.cellForRow(at: IndexPath(row: 0, section: 1)) as! YSAddTextTableViewCell
//        let cell2 = tableViewGrouped.cellForRow(at: IndexPath(row: 0, section: 2)) as! YSEditMeTableViewCell
        if cell0.images.count == 0 && postWhat == 2{
            SVProgressHUD.showError(withStatus: "加点图片吧")
            return
        }
        guard let thisTitle = cell1.textField.text, !thisTitle.isEmpty else {
            SVProgressHUD.showError(withStatus: "加个标题吧")
            return
        }
        let content = cell1.textView.text
        
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        switch postWhat {
        case 1:
            WXActivityIndicatorView.start()
            
            NetworkManager.providerHomeApi.request(.doTransfer(user_id: userId, transfer_title: thisTitle, transfer_desc: content ?? "", transfer_type: type, images: cell0.images)).mapJSON().subscribe(onNext: { (res) in
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
                    SVProgressHUD.showSuccess(withStatus: msg ?? "发布成功")
                    NotificationCenter.default.post(name: NotifyCircleAdded, object: nil)
                    self.dismiss(animated: true, completion: nil)
                    
                }else{
                    SVProgressHUD.showError(withStatus: msg ?? "发布失败")
                }
                
            }, onError: { (err) in
                WXActivityIndicatorView.stop()
            }).addDisposableTo(disposeBag)

        case 0:
            WXActivityIndicatorView.start()
            
            NetworkManager.providerHomeApi.request(.doPost(post_title: thisTitle, post_desc: content ?? "", post_type: "1", user_id: userId, images: cell0.images)).mapJSON().subscribe(onNext: { (res) in
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
                    SVProgressHUD.showSuccess(withStatus: msg ?? "发布成功")
                    NotificationCenter.default.post(name: NotifyCircleAdded, object: nil)
                    self.dismiss(animated: true, completion: nil)
                    
                }else{
                    SVProgressHUD.showError(withStatus: msg ?? "发布失败")
                }
                
            }, onError: { (err) in
                WXActivityIndicatorView.stop()
            }).addDisposableTo(disposeBag)

        default:
            WXActivityIndicatorView.start()
            
            NetworkManager.providerHomeApi.request(.doPost(post_title: thisTitle, post_desc: content ?? "", post_type: "2", user_id: userId, images: cell0.images)).mapJSON().subscribe(onNext: { (res) in
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
                    SVProgressHUD.showSuccess(withStatus: msg ?? "发布成功")
                    NotificationCenter.default.post(name: NotifyCircleAdded, object: nil)
                    self.dismiss(animated: true, completion: nil)
                    
                }else{
                    SVProgressHUD.showError(withStatus: msg ?? "发布失败")
                }
                
            }, onError: { (err) in
                WXActivityIndicatorView.stop()
            }).addDisposableTo(disposeBag)

        }
        
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

 

}

extension YSTransferAddViewController: UITableViewDelegate ,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.postWhat == 1 ? 3 : 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageTableViewCell", for: indexPath) as! AddImageTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YSAddTextTableViewCell", for: indexPath) as! YSAddTextTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YSEditMeTableViewCell", for: indexPath) as! YSEditMeTableViewCell
            cell.ys_titleLabel.text = "置换类型"
            cell.detailLabel.text = self.type == "2" ? "置换": "馈赠"
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            let vc = DVActionSheetVC()
            let arr = ["置换","馈赠"]
            vc.moreButtonTitles = arr
            vc.finishSelect = { (index) in
                self.type = index == 0 ? "2" : "1"
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
            self.present(vc, animated: true, completion: nil)
        }
    }
}
