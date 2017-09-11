//
//  YSAnnounceViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
let pageNum = 10
class YSAnnounceViewController: RootViewController {
    var contents: [Announce] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "群主公告"
        setupUI()
        setupRefresh()
        loadServerData()
    }
    
    override func loadServerData() {
        super.loadServerData()
        guard let user_id = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        NetworkManager.providerHomeApi.request(.getAnnounceList(user_id: user_id))
        .mapArray(Announce.self).subscribe(onNext: { (list) in
            guard list.count > 0 else {return}
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension YSAnnounceViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnounceTableViewCell", for: indexPath) as! AnnounceTableViewCell
        cell.annouce = contents[indexPath.row]
        return cell
    }
}
