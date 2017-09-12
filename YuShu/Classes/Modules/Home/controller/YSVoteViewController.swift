//
//  YSVoteViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSVoteViewController: RootViewController {
    var contents: [Vote] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "民意投票"
        setupUI()
        setupRefresh()
        loadServerData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func loadServerData() {
        super.loadServerData()
        guard let user_id = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        NetworkManager.providerHomeApi.request(.getVoteList(user_id: user_id, page: page))
            .mapArray(Vote.self).subscribe(onNext: { (list) in
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
        tableView.register(str: "YSVoteTableViewCell")
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.separatorStyle = .none
    }

}

extension YSVoteViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSVoteTableViewCell", for: indexPath) as! YSVoteTableViewCell
        cell.vote = contents[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vote = contents[indexPath.row]
        let vc = YSVoteDetailViewController()
        vc.voteId = vote.vote_id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
