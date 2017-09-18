//
//  YSTransferDetailViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/15.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import SVProgressHUD
class YSTransferDetailViewController: RootViewController {

    var transferId = "" {
        didSet{
            
        }
    }
    
    var transfer: Transfer!
    
    var contents: [Comment] = []
    
    let headView = YSTransferDetailHeadView.default()!
    
    let tableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 10))
    let commentView = CommentToolView.default()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInit()
        setupRx()
        setupRefresh()
        loadServerData()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 50, 0))
        }
        tableView.register(str: "YSCommentTableViewCell")
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.separatorStyle = .none
        
        
        
        let h = UIView.transferDetailHeadViewH(transfer: transfer)
        tableViewHeader.setHeight(h: h)
        
        tableViewHeader.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.edges.equalTo(tableViewHeader).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        headView.transfer = transfer
        
        tableView.tableHeaderView = tableViewHeader
        
        view.addSubview(commentView)
        
        commentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(50)
        }
    }
    func setupInit() {
        
        
        let block =  { [unowned self] (btn: UIButton) in
            switch btn.tag {
            case 0:
                self.like(btn: btn)
            case 1:
                self.save()
            case 2:
                self.send()
            default:
                return
            }
        }
        commentView.actionBlock = block
        
        
    }
    func setupRx() {
        
    }
    
    override func loadServerData() {
        super.loadServerData()
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        //评论
        NetworkManager.providerHomeApi.request(.getCommentList(user_id: userId, type: "transfer", item_id: transferId, page: page))
            .mapArray(Comment.self).subscribe(onNext: { (list) in
                
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
        //内容
        if !tableView.mj_footer.isRefreshing() {
            
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
//MARK: 评论操作
extension YSTransferDetailViewController{
    func like(btn bt: UIButton) {
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        WXActivityIndicatorView.start()
        NetworkManager.providerHomeApi.request(.doPraise(user_id: userId, praise_type: "transfer", praise_item_id: transferId)).mapJSON().subscribe(onNext: { (res) in
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
                SVProgressHUD.showSuccess(withStatus: msg ?? "点赞成功")
                bt.isSelected = !bt.isSelected
            }else{
                SVProgressHUD.showError(withStatus: msg ?? "点赞失败")
            }
            
        }, onError: { (err) in
            WXActivityIndicatorView.stop()
        }).addDisposableTo(disposeBag)
    }
    func save() {
        
    }
    
    func send() {
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        WXActivityIndicatorView.start()
        NetworkManager.providerHomeApi.request(.doComment(user_id: userId, comment_type: "transfer", comment_item_id: transferId, comment_desc: commentView.textField.text)).mapJSON().subscribe(onNext: { (res) in
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
                SVProgressHUD.showSuccess(withStatus: msg ?? "评论成功")
                self.tableView.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: msg ?? "评论失败")
            }
        }, onError: { (err) in
            
        }).addDisposableTo(disposeBag)
    }
}

extension YSTransferDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView.tableViewHeaderView(height: 40, title: "评论 \(contents.count)")
        return container
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSCommentTableViewCell", for: indexPath) as! YSCommentTableViewCell
        cell.comment = contents[indexPath.row]
        return cell
    }
}

