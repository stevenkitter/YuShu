//
//  YSAnnounceDetailViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/12.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
class YSAnnounceDetailViewController: RootViewController {
    var announceId = "" {
        didSet{
            webUrl = AnnounceUrl + announceId
        }
    }
    var webUrl = ""
    
    var contents: [Comment] = []
    var praiseUsers: [PraiseUser] = []
    
    let progressView = UIProgressView(progressViewStyle: .default).then{
        $0.progressTintColor = KNaviColor
    }
    let webView = WKWebView().then{
        $0.scrollView.keyboardDismissMode = .onDrag
        $0.scrollView.isScrollEnabled = false
    }
    let tableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 10))
    let commentView = CommentToolView.default()!
    let praiseBtn = UIButton.buttonWithImage(image: UIImage(named: "like")!.scaleToSize(size: CGSize(width: 20, height: 20))!)
    
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
        tableView.separatorStyle = .singleLine
        tableViewHeader.backgroundColor = UIColor.white
        tableViewHeader.addSubview(webView)
        tableViewHeader.addSubview(praiseBtn)
        
        webView.addSubview(progressView)
        webView.navigationDelegate = self
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.tableViewHeader).inset(UIEdgeInsetsMake(0, 0, 40, 0))
        }
        praiseBtn.snp.makeConstraints { (make) in
            make.left.equalTo(tableViewHeader).offset(10)
            make.top.equalTo(webView.snp.bottom).offset(5)
            make.bottom.equalTo(tableViewHeader).offset(-5)
        }
        progressView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(webView)
            make.height.equalTo(2)
        }
        tableView.tableHeaderView = tableViewHeader
        
        view.addSubview(commentView)
        commentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(50)
        }
    }
    func setupInit() {
        let req = URLRequest(url: URL(string: webUrl)!)
        webView.load(req)
        
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
        webView.rx.observe(Double.self, "estimatedProgress").subscribe(onNext: { [unowned self] (progress) in
            self.progressView.progress = Float(progress ?? 0)
            self.progressView.isHidden = progress == 1
        }).addDisposableTo(disposeBag)
    }
    override func loadServerData() {
        super.loadServerData()
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        NetworkManager.providerHomeApi.request(.getCommentList(user_id: userId, type: "adminnotice", item_id: announceId, page: page))
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
        
        
        NetworkManager.providerHomeApi.request(.getPraiseList(user_id: userId, type: "adminnotice", item_id: announceId)).mapArray(PraiseUser.self).subscribe(onNext: { (list) in
            self.praiseBtn.setTitle(" \(list.count)", for: .normal)
            for user in list {
                if userId == user.user_id {
                    self.commentView.likeButton.isSelected = true
                    return
                }
            }
            self.commentView.likeButton.isSelected = false
        }, onError: { (err) in
            self.praiseBtn.setTitle(" 0", for: .normal)
        }).addDisposableTo(disposeBag)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    

}
//MARK: 评论操作
extension YSAnnounceDetailViewController{
    func like(btn bt: UIButton) {
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        WXActivityIndicatorView.start()
        NetworkManager.providerHomeApi.request(.doPraise(user_id: userId, praise_type: "adminnotice", praise_item_id: announceId)).mapJSON().subscribe(onNext: { (res) in
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
        NetworkManager.providerHomeApi.request(.doComment(user_id: userId, comment_type: "adminnotice", comment_item_id: announceId, comment_desc: commentView.textField.text)).mapJSON().subscribe(onNext: { (res) in
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

extension YSAnnounceDetailViewController: UITableViewDelegate, UITableViewDataSource {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension YSAnnounceDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
        webView.evaluateJavaScript("document.body.scrollHeight") { (content, err) in
            
            if let h = content as? CGFloat {
                self.tableViewHeader.setHeight(h: h + 40)
                self.tableView.beginUpdates()
                self.tableView.tableHeaderView = self.tableViewHeader
                self.tableView.endUpdates()
            }
        }
    }
}
