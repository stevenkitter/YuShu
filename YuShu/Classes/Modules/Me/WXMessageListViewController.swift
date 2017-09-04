//
//  WXMessageListViewController.swift
//  InternManager
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class WXMessageListViewController: RootViewController {
    var wxIsComment = false
    var messages: [WXMessage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefresh()
        self.tableView.mj_header.beginRefreshing()
        // Do any additional setup after loading the view.
    }
    func setupUI(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0,0, 0))
        }
        tableView.register(str: "WXMessageListTableViewCell")
    }
    override func loadServerData() {
        super.loadServerData()
        let user_id = UserManager.shareUserManager.curUserInfo?.id ?? ""
        NetworkManager.providerUserApi
            .request(.myMessage(isComment: wxIsComment, user_id: user_id, page: page))
            .mapArray(WXMessage.self)
            .subscribe(onNext: { [unowned self] (models) in
                if self.page == 1 {
                    self.messages.removeAll()
                }
                self.messages.append(contentsOf: models)
                
                self.page += 1
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                if models.count < 10 {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self.tableView.mj_footer.endRefreshing()
                }
                }, onError: { (err) in
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    
            })
            .addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
extension WXMessageListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WXMessageListTableViewCell", for: indexPath) as! WXMessageListTableViewCell
        cell.message = messages[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        if wxIsComment {
            let vc = CommentListViewController()
            vc.articleID = message.article_id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = CircleXViewController()
            vc.friend_id = message.friendcircle_id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
