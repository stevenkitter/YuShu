//
//  CircleXViewController.swift
//  InternManager
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD
import NotificationCenter
class CircleXViewController: RootViewController {
    var circles: [Circle] = []
    var friend_id = ""
    var user_id = UserManager.shareUserManager.curUserInfo?.id ?? ""
    var commentTool = CommentToolView.default()!
    var selectedRow: Int = 0
    var selectedCommentRow: Int = 0
    var replyComment: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInit()
        setupRefresh()
        tableView.mj_header.beginRefreshing()
        
        NotificationCenter.default
            .rx.notification(NotifyCircleAdded).subscribe(onNext: { [unowned self] (_) in
                self.tableView.mj_header.beginRefreshing()
            }, onError: { (erro) in
                
        }).addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setupUI(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0,55, 0))
        }
        tableView.register(UINib(nibName: "WXCircleTableViewCell", bundle: nil), forCellReuseIdentifier: "WXCircleTableViewCell")
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "发表按钮"), for: .normal)
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-30)
            make.bottom.equalTo(self.view).offset(-120)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        btn.rx.tap.subscribe(onNext: { [unowned self] (_) in
            self.goPost()
        }, onError: { (erro) in
            
        }).addDisposableTo(disposeBag)
        
        self.view.addSubview(commentTool)
        commentTool.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        commentTool.onlySend()
    }
    
    func goPost() {
        let vc = WXPostCircleViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupInit() {
        let block = { [unowned self] (btn: UIButton) in
            guard self.showLogin() else{
                return
            }
            switch btn.tag {
            case 0:
                print("")
            case 1:
                print("")
            case 2:
                self.send()
            default:
                break
            }
        }
        commentTool.actionBlock = block
    }
    func send() {
        if selectedRow >= circles.count {
            return
        }
        let userid = UserManager.shareUserManager.curUserInfo?.id ?? ""
        let circle = circles[selectedRow]
        
        let aboutid = selectedCommentRow == -1 ? (circle.user_id ?? "") : (circle.comment[selectedCommentRow].user_id ?? "")
        WXActivityIndicatorView.start()
        NetworkManager.providerCircleApi.request(.sendComment(content: commentTool.textField.text, user_id: userid, friend_id: circle.friend_id ?? "", about_user_id: aboutid))
        .mapJSON()
        .subscribe(onNext: { [unowned self] (res) in
            WXActivityIndicatorView.stop()
            guard let respon = res as? Dictionary<String, Any> else{
                return
            }
            guard let data = respon["data"] as? Dictionary<String, Any> else {
                return
            }
            SVProgressHUD.showSuccess(withStatus: data["msg"] as? String ?? "")
            var comments = circle.comment
            var newComment = CircleComment(JSON: data)
            newComment?.user_nickname = UserManager.shareUserManager.curUserInfo?.user_nickname
            newComment?.user_phone = UserManager.shareUserManager.curUserInfo?.user_phone
            comments.append(newComment!)
            self.circles[self.selectedRow].comment = comments
            self.tableView.reloadRows(at: [IndexPath(row: self.selectedRow, section: 0)], with: .fade)
            self.commentTool.textField.text = ""
            self.view.endEditing(true)
            
            
        }, onError: { (error) in
            WXActivityIndicatorView.stop()
        }).addDisposableTo(disposeBag)
        
    }
    override func loadServerData() {
        super.loadServerData()
        NetworkManager.providerCircleApi.request(.circles(friend_id: friend_id, user_id: user_id, page: page)).mapArray(Circle.self).subscribe(onNext: { (models) in
            if self.page == 1 {
                self.circles.removeAll()
            }
            self.circles.append(contentsOf: models)
            
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
        }).addDisposableTo(disposeBag)
    }

}
extension CircleXViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return circles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let circle = circles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WXCircleTableViewCell", for: indexPath) as! WXCircleTableViewCell
        cell.circle = circle
        cell.closure = { [unowned self] (tag) in
            self.commentTool.textField.becomeFirstResponder()
            self.selectedRow = indexPath.row
            self.selectedCommentRow = tag
            if tag == -1 {
                self.replyComment = true
                let name = (circle.user_nickname ?? "").exactStr(one: "", two: circle.user_phone ?? "")
                let str = "@\(name) "
                self.commentTool.textField.text = str
            }else{
                
                let subComment = circle.comment[tag]
                let name = (subComment.user_nickname ?? "").exactStr(one: "", two: subComment.user_phone ?? "")
                let str = "@\(name) "
                self.commentTool.textField.text = str
                
            }

        }
        return cell
    }
}
