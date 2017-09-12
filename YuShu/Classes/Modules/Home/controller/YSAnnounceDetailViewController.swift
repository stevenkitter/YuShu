//
//  YSAnnounceDetailViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/12.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import WebKit
class YSAnnounceDetailViewController: RootViewController {
    var announceId = "" {
        didSet{
            webUrl = AnnounceUrl + announceId
        }
    }
    var webUrl = ""
    
    var contents: [Comment] = []
    
    let progressView = UIProgressView(progressViewStyle: .default).then{
        $0.progressTintColor = KNaviColor
    }
    let webView = WKWebView().then{
        $0.scrollView.keyboardDismissMode = .onDrag
        $0.scrollView.isScrollEnabled = false
    }
    let tableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
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
        
        tableViewHeader.addSubview(webView)
        webView.addSubview(progressView)
        webView.navigationDelegate = self
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.tableViewHeader).inset(UIEdgeInsetsMake(0, 0, 0, 0))
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
                print("点赞")
            case 1:
                print("分享")
            case 2:
                print("发送")
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
        NetworkManager.providerHomeApi.request(.getCommentList(user_id: userId, type: "", item_id: announceId, page: page))
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
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
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
        return cell
    }
}

extension YSAnnounceDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
        webView.evaluateJavaScript("document.body.scrollHeight") { (content, err) in
            
            if let h = content as? CGFloat {
                self.tableViewHeader.setHeight(h: h)
                self.tableView.tableHeaderView = self.tableViewHeader
            }
        }
    }
}
