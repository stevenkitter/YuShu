//
//  YSMyPostViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/29.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSMyPostViewController: RootViewController {
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的发布"
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        let vc0 = YSMYNewCircleViewController()
        vc0.title = "我的动态"
        vc0.parentVc = self
        let vc1 = YSMYTransferViewController()
        vc1.title = "我的转让"
        vc1.parentVc = self
        let vc2 = YSMYSuggestViewController()
        vc2.title = "我的建议"
        vc2.parentVc = self
        
        let vcs = [vc0, vc1, vc2]
        
        pageMenu = CAPSPageMenu(viewControllers: vcs, frame: self.view.bounds, pageMenuOptions: pageParameters)
        view.addSubview(pageMenu!.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

class YSMYNewCircleViewController: YSNewCircleViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的动态"
        btn.isHidden = true
    }
    override func loadServerData() {
        if tableView.mj_header.isRefreshing() {
            page = 1
            tableView.mj_footer.resetNoMoreData()
        }
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        NetworkManager.providerUserApi.request(.getMyPost(type: 1, user_id: userId)).mapArray(PostSuggest.self).subscribe(onNext: { (list) in
            if self.page == 1 {
                self.contents.removeAll()
            }
            self.contents.append(contentsOf: list)
            self.page += 1
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            if list.count < pageNum {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }

        }, onError: { (err) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }).addDisposableTo(disposeBag)
    }
}

class YSMYTransferViewController: YSTransferViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的转让"
        btn.isHidden = true
    }
    override func loadServerData() {
        if tableView.mj_header.isRefreshing() {
            page = 1
            tableView.mj_footer.resetNoMoreData()
        }
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        NetworkManager.providerUserApi.request(.getMyPost(type: 2, user_id: userId)).mapArray(Transfer.self).subscribe(onNext: { (list) in
            if self.page == 1 {
                self.contents.removeAll()
            }
            self.contents.append(contentsOf: list)
            self.page += 1
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            if list.count < pageNum {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
        }, onError: { (err) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }).addDisposableTo(disposeBag)
    }
}
class YSMYSuggestViewController: YSSuggestViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的建议"
        btn.isHidden = true
    }
    override func loadServerData() {
        if tableView.mj_header.isRefreshing() {
            page = 1
            tableView.mj_footer.resetNoMoreData()
        }
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        NetworkManager.providerUserApi.request(.getMyPost(type: 3, user_id: userId)).mapArray(PostSuggest.self).subscribe(onNext: { (list) in
            if self.page == 1 {
                self.contents.removeAll()
            }
            self.contents.append(contentsOf: list)
            self.page += 1
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            if list.count < pageNum {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
        }, onError: { (err) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }).addDisposableTo(disposeBag)
    }
}
