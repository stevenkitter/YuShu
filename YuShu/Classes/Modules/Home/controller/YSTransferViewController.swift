//
//  YSTransferViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSTransferViewController: RootViewController {
    var contents: [Transfer] = []
    var parentVc: RootViewController?
    
    let btn = UIButton.buttonWithImage(image: UIImage(named: "tab_willsell")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "闲置转让"
        setupUI()
        setupRefresh()
        loadServerData()
        setupRx()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        tableView.register(str: "YSTransferTableViewCell")
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.separatorStyle = .singleLine
        
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(addTransfer), for: .touchUpInside)
        btn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20)
            make.bottom.equalTo(self.view).offset(-50)
            
        }
    }
    
    override func loadServerData() {
        super.loadServerData()
        NetworkManager.providerHomeApi.request(.getTransferList(page: page)).mapArray(Transfer.self).subscribe(onNext: { (list) in
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
    
    func addTransfer() {
        let vc = YSTransferAddViewController()
        vc.postWhat = 1
        parentVc?.present(vc, animated: true, completion: nil)
    }
    
    func setupRx() {
        NotificationCenter.default.rx.notification(NotifyCircleAdded).subscribe(onNext: { [unowned self] (_) in
            self.tableView.mj_header.beginRefreshing()
            
            }, onError: { (err) in
                
        }).addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
   

}

extension YSTransferViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSTransferTableViewCell", for: indexPath) as! YSTransferTableViewCell
        cell.transfer = contents[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tr = contents[indexPath.row]
        let vc = YSTransferDetailViewController()
        vc.transfer = tr
        vc.transferId = tr.transfer_id ?? ""
        parentVc?.navigationController?.pushViewController(vc, animated: true)
    }
}

class YSNewCircleViewController: RootViewController {
    var contents: [PostSuggest] = []
    var parentVc: RootViewController?
    
    let btn = UIButton.buttonWithImage(image: UIImage(named: "tab_willsell")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "最新动态"
        setupUI()
        setupRefresh()
        loadServerData()
        setupRx()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        tableView.register(str: "YSPostSuggestTableViewCell")
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.separatorStyle = .singleLine
        
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(addTransfer), for: .touchUpInside)
        btn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20)
            make.bottom.equalTo(self.view).offset(-50)
            
        }
    }
    
    override func loadServerData() {
        super.loadServerData()
        NetworkManager.providerHomeApi.request(.postInfo(page: page, post_type: "1")).mapArray(PostSuggest.self).subscribe(onNext: { (list) in
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
    func setupRx() {
        NotificationCenter.default.rx.notification(NotifyCircleAdded).subscribe(onNext: { [unowned self] (_) in
            self.tableView.mj_header.beginRefreshing()
            
            }, onError: { (err) in
                
        }).addDisposableTo(disposeBag)
    }
    
    func addTransfer() {
        let vc = YSTransferAddViewController()
        vc.postWhat = 0
        parentVc?.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
    
}

extension YSNewCircleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSPostSuggestTableViewCell", for: indexPath) as! YSPostSuggestTableViewCell
        cell.postSuggest = contents[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tr = contents[indexPath.row]
        let vc = YSPostSuggestDetailViewController()
        vc.postSuggest = tr
        vc.transferId = tr.post_id ?? ""
        parentVc?.navigationController?.pushViewController(vc, animated: true)
    }
}


class YSSuggestViewController: RootViewController {
    var contents: [PostSuggest] = []
    var parentVc: RootViewController?
    
    
    let btn = UIButton.buttonWithImage(image: UIImage(named: "tab_willsell")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "公共建议"
        setupUI()
        setupRefresh()
        loadServerData()
        setupRx()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        tableView.register(str: "YSPostSuggestTableViewCell")
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.separatorStyle = .singleLine
        
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(addTransfer), for: .touchUpInside)
        btn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20)
            make.bottom.equalTo(self.view).offset(-50)
            
        }
    }
    
    override func loadServerData() {
        super.loadServerData()
        NetworkManager.providerHomeApi.request(.postInfo(page: page, post_type: "2")).mapArray(PostSuggest.self).subscribe(onNext: { (list) in
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
    
    func addTransfer() {
        let vc = YSTransferAddViewController()
        vc.postWhat = 2
        parentVc?.present(vc, animated: true, completion: nil)
    }
    
    func setupRx() {
        NotificationCenter.default.rx.notification(NotifyCircleAdded).subscribe(onNext: { [unowned self] (_) in
            self.tableView.mj_header.beginRefreshing()
            
            }, onError: { (err) in
                
        }).addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
    
}

extension YSSuggestViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSPostSuggestTableViewCell", for: indexPath) as! YSPostSuggestTableViewCell
        cell.postSuggest = contents[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tr = contents[indexPath.row]
        let vc = YSPostSuggestDetailViewController()
        vc.postSuggest = tr
        vc.transferId = tr.post_id ?? ""
        parentVc?.navigationController?.pushViewController(vc, animated: true)
    }
}

class YSNewCirclesViewController: RootViewController {
    var contents: [PostSuggest] = []
    var parentVc: RootViewController?
    let footer = YSNextPageView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 50))
    
    let btn = UIButton.buttonWithImage(image: UIImage(named: "tab_willsell")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "最新通知"
        setupUI()
        setupRefresh()
        loadServerData()
        setupRx()
    }
    override func setupRefresh() {
        tableView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
    }
    
    override func loadServerData() {
        super.loadServerData()
        NetworkManager.providerHomeApi.request(.postInfo(page: page, post_type: "1")).mapObject(PostSuggestInfo.self).subscribe(onNext: { (info) in
            self.contents.removeAll()
            
            self.contents.append(contentsOf: info.list)
            
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            
            if let myPage = Int(info.page_count ?? "") {
                self.footer.allPage = myPage
            }
            
            
            self.footer.page = self.page
            
        }, onError: { (err) in
            self.tableView.mj_header.endRefreshing()
                    }).addDisposableTo(disposeBag)
    }
    
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        tableView.register(str: "AnnounceTableViewCell")
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.separatorStyle = .none
        
        tableView.tableFooterView = footer
        
        footer.delegate = self
        
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(addTransfer), for: .touchUpInside)
        btn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20)
            make.bottom.equalTo(self.view).offset(-50)
            
        }
    }
    
    func addTransfer() {
        let vc = YSTransferAddViewController()
        vc.postWhat = 0
        parentVc?.present(vc, animated: true, completion: nil)
    }
    func setupRx() {
        NotificationCenter.default.rx.notification(NotifyCircleAdded).subscribe(onNext: { [unowned self] (_) in
            self.tableView.mj_header.beginRefreshing()
            
            }, onError: { (err) in
                
        }).addDisposableTo(disposeBag)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension YSNewCirclesViewController: YSNextPageViewDelegate {
    func forward() {
        page -= 1
        loadServerData()
    }
    func nextPage() {
        page += 1
        loadServerData()
    }
    func go(page: Int) {
        self.page = page
        loadServerData()
    }
    
}

extension YSNewCirclesViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mo = contents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnounceTableViewCell", for: indexPath) as! AnnounceTableViewCell
//        cell.annouce = contents[indexPath.row]
        cell.ys_titleLabel.text = mo.post_title
        cell.timeLabel.text = (mo.post_addtime ?? "").timeStr()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tr = contents[indexPath.row]
        let vc = YSPostSuggestDetailViewController()
        vc.postSuggest = tr
        vc.transferId = tr.post_id ?? ""
        parentVc?.navigationController?.pushViewController(vc, animated: true)
        
    }
}


class YSSuggestsViewController: RootViewController {
    var contents: [PostSuggest] = []
    var parentVc: RootViewController?
    let footer = YSNextPageView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 50))
    
     let btn = UIButton.buttonWithImage(image: UIImage(named: "tab_willsell")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "公共建议"
        setupUI()
        setupRefresh()
        loadServerData()
        setupRx()
    }
    override func setupRefresh() {
        tableView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
    }
    
    override func loadServerData() {
        super.loadServerData()
        NetworkManager.providerHomeApi.request(.postInfo(page: page, post_type: "1")).mapObject(PostSuggestInfo.self).subscribe(onNext: { (info) in
            self.contents.removeAll()
            
            self.contents.append(contentsOf: info.list)
            
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            
            if let myPage = Int(info.page_count ?? "") {
                self.footer.allPage = myPage
            }
            
            
            self.footer.page = self.page
            
        }, onError: { (err) in
            self.tableView.mj_header.endRefreshing()

        }).addDisposableTo(disposeBag)
    }
    
    func addTransfer() {
        let vc = YSTransferAddViewController()
        vc.postWhat = 2
        parentVc?.present(vc, animated: true, completion: nil)
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        tableView.register(str: "AnnounceTableViewCell")
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.separatorStyle = .none
        
        tableView.tableFooterView = footer
        
        footer.delegate = self
        
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(addTransfer), for: .touchUpInside)
        btn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20)
            make.bottom.equalTo(self.view).offset(-50)
            
        }
    }
    func setupRx() {
        NotificationCenter.default.rx.notification(NotifyCircleAdded).subscribe(onNext: { [unowned self] (_) in
            self.tableView.mj_header.beginRefreshing()
            
            }, onError: { (err) in
                
        }).addDisposableTo(disposeBag)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension YSSuggestsViewController: YSNextPageViewDelegate {
    func forward() {
        page -= 1
        loadServerData()
    }
    func nextPage() {
        page += 1
        loadServerData()
    }
    func go(page: Int) {
        self.page = page
        loadServerData()
    }
    
}

extension YSSuggestsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mo = contents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnounceTableViewCell", for: indexPath) as! AnnounceTableViewCell
        cell.ys_titleLabel.text = mo.post_title
        cell.timeLabel.text = (mo.post_addtime ?? "").timeStr()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tr = contents[indexPath.row]
        let vc = YSPostSuggestDetailViewController()
        vc.postSuggest = tr
        vc.transferId = tr.post_id ?? ""
        parentVc?.navigationController?.pushViewController(vc, animated: true)
        
    }
}

