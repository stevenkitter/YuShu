//
//  CommentListViewController.swift
//  InternManager
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RxSwift
import SVProgressHUD
class CommentListViewController: RootViewController {
    
    public var articleID = ""
    fileprivate var commentList: [Comment] = []
    var commentTool = CommentToolView.default()!
    var selectedCommentID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefresh()
        setupInit()
        tableView.mj_header.beginRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    func setupUI() {
        self.tableView.register(UINib(nibName: "CommentListTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentListTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { [unowned self] (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 55, 0))
        }
        self.view.addSubview(commentTool)
        commentTool.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
    
    func setupInit() {
        let block = { [unowned self] (btn: UIButton) in
            guard self.showLogin() else{
                return
            }
            switch btn.tag {
            case 0:
                self.like(btn)
            case 1:
                print("share")
            case 2:
                self.send()
            default:
                break
            }
        }
        commentTool.actionBlock = block
        commentTool.article_id = articleID
        commentTool.loadUserInfo()
    }
    
    func like(_ btn: UIButton) {
        WXActivityIndicatorView.start()
        NetworkManager.providerHomeApi.request(.setCollect(article_id: articleID, user_id: UserManager.shareUserManager.curUserInfo?.id ?? "")).mapJSON().subscribe(onNext: { (res) in
            WXActivityIndicatorView.stop()
            guard let respon = res as? Dictionary<String, Any> else{
                return
            }
            guard let data = respon["data"] as? Dictionary<String, Any> else {
                return
            }
            SVProgressHUD.showSuccess(withStatus: data["msg"] as? String ?? "")
            btn.isSelected = !btn.isSelected
        }, onError: { (er) in
            WXActivityIndicatorView.stop()
        }).addDisposableTo(disposeBag)
    }
    
    func send() {
        WXActivityIndicatorView.start()
        var comment_id = ""
        if commentTool.textField.text.contains("@") {
            comment_id = selectedCommentID ?? ""
        }
        let userID = UserManager.shareUserManager.curUserInfo?.id ?? ""
        NetworkManager.providerHomeApi.request(.sendCommentComment(user_id: userID, article_id: articleID, content: commentTool.textField.text, comment_id: comment_id)).mapJSON()
            .subscribe(onNext: { [unowned self] (res) in
                WXActivityIndicatorView.stop()
                guard let respon = res as? Dictionary<String, Any> else{
                    return
                }
                guard let data = respon["data"] as? Dictionary<String, Any> else {
                    return
                }
                SVProgressHUD.showSuccess(withStatus: data["msg"] as? String ?? "")
                self.commentTool.textField.text = ""
                self.view.endEditing(true)
                self.tableView.mj_header.beginRefreshing()
                }, onError: { (err) in
                    WXActivityIndicatorView.stop()
            }).addDisposableTo(disposeBag)
    }

    
    override func loadServerData() {
        super.loadServerData()
        NetworkManager.providerHomeApi
            .request(.getComment(article_id: articleID, user_id: UserManager.shareUserManager.curUserInfo?.id ?? "", page: page))
            .mapArray(Comment.self)
            .subscribe(onNext: { [unowned self] (models) in
                if self.page == 1 {
                    self.commentList.removeAll()
                }
                self.commentList.append(contentsOf: models)
                
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
        
    }
    

    

}
extension CommentListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = commentList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentListTableViewCell", for: indexPath) as! CommentListTableViewCell
        cell.comment = comment
        cell.closure = { [unowned self] (tag) in
            self.commentTool.textField.becomeFirstResponder()
            self.selectedCommentID = comment.comment_id
            if tag == -1 {
                let name = comment.user_nickName.exactStr(one: comment.user_name, two: comment.user_phone)
                let str = "@\(name) "
                self.commentTool.textField.text = str
            }else{
                let subComment = comment.replay[tag]
                let name = subComment.user_nickName.exactStr(one: subComment.user_name, two: subComment.user_phone)
                let str = "@\(name) "
                self.commentTool.textField.text = str
                
            }
            
        }
        return cell
    }
}
