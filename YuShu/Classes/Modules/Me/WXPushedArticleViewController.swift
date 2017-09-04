//
//  WXPushedArticleViewController.swift
//  InternManager
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit



class WXPushedArticleViewController: RootViewController {
    var collectedCircles: [Article] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefresh()
        self.tableView.mj_header.beginRefreshing()
    }
    func setupUI() {
        self.title = "推送的文章"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0,0, 0))
        }
        tableView.register(str: "HomeTableViewCell")
    }
    override func loadServerData() {
        super.loadServerData()
        //:MARK 加载内容
        let user_id = UserManager.shareUserManager.curUserInfo?.id ?? ""
        NetworkManager.providerUserApi
            .request(.getPushedArticles(user_id: user_id, page: page))
            .mapArray(Article.self)
            .subscribe(onNext: { [unowned self] (models) in
                if self.page == 1 {
                    self.collectedCircles.removeAll()
                }
                self.collectedCircles.append(contentsOf: models)
                
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
extension WXPushedArticleViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectedCircles.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = collectedCircles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HomeTableViewCell
        cell.model = item
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = collectedCircles[indexPath.row]
        let vc = ArticleDetailViewController()
        let webStr = WebUrl + (article.article_id ?? "") + "&user_id=" + (UserManager.shareUserManager.curUserInfo?.id ?? "")
        vc.articleID = article.article_id ?? ""
        vc.webURLStr = webStr
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

