//
//  RootViewController.swift
//  InternManager
//
//  Created by apple on 2017/7/31.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SVProgressHUD
class RootViewController: UIViewController {
    let disposeBag = DisposeBag()
    let tableView = UITableView(frame: CGRect.zero, style: .plain).then {
        $0.estimatedRowHeight = 50
        $0.tableFooterView = UIView()
    }
    
    let tableViewGrouped = UITableView(frame: CGRect.zero, style: .grouped).then {
        $0.estimatedRowHeight = 50
        $0.tableFooterView = UIView()
        $0.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 0.01))
    }
    
    var collectionView: UICollectionView! = nil
    var page = 1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setupRefresh() {
        tableView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
        tableView.mj_footer = RefreshFooter(refreshingBlock: {
            [unowned self] in
            self.loadServerData()
        })
    }
    
    func loadServerData() {
        if tableView.mj_header.isRefreshing() {
            page = 1
            if tableView.mj_footer != nil {
                tableView.mj_footer.resetNoMoreData()
            }
            
        }
    }
    
    func loadUserInfo(ok: (()->Void)?) {
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        NetworkManager.providerUserApi.request(.userInfo(user_id: userId)).mapObject(UserInfo.self)
            .subscribe(onNext: { (info) in
                UserManager.shareUserManager.curUserInfo = info
                ok?()
            }, onError: { (err) in
                
            }).addDisposableTo(disposeBag)
    }

    func hideNavigationBar() {
        
        self.navigationController?.setNavigationBarHidden(self.tableView.mj_offsetY <= 150, animated: false)

        
        let offset = min(max(0, (self.tableView.mj_offsetY - 150) / 150), 1)
        let color = KNaviColor.alpha(offset)
        self.navigationController?.navigationBar.setBackgroundImage(color.createImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIColor.clear.createImage()
        
    }
    
    func webDetail(url: String) {
        let vc = YSWebViewController()
        vc.url = url
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension RootViewController {
    func changeInfo(key: String, str: String) {
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        
        NetworkManager.providerUserApi.request(.update(user_id: userId, info: key, value: str))
            .mapJSON().subscribe(onNext: { (res) in
                
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
                    
                }else{
                    SVProgressHUD.showError(withStatus: msg ?? "修改失败")
                }
                
                
            }, onError: { (err) in
                
            }).addDisposableTo(disposeBag)
    }

}
extension RootViewController {
    func goPersonal(tapG: UITapGestureRecognizer) {
        
        guard let tag = tapG.view?.tag else {return}
        let vc = YSPersonalViewController()
        vc.userId = "\(tag)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
