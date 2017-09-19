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
    
    let footer = YSNextPageView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "群主公告"
        setupUI()
        setupRefresh()
        loadServerData()
    }
    override func setupRefresh() {
        tableView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
    }
    
    override func loadServerData() {
        super.loadServerData()
        guard let user_id = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        NetworkManager.providerHomeApi.request(.getAnnounceList(user_id: user_id,page: page))
        .mapObject(AnnounceInfo.self).subscribe(onNext: { (info) in
            
            self.contents.removeAll()
            
            self.contents.append(contentsOf: info.list)
            
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            
            if let myPage = Int(info.page_count ?? "") {
                self.footer.page = myPage
            }
            
            if let myAllPage = Int(info.total_count ?? "") {
                self.footer.allPage = myAllPage
            }
            
           
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension YSAnnounceViewController: YSNextPageViewDelegate {
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

extension YSAnnounceViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnounceTableViewCell", for: indexPath) as! AnnounceTableViewCell
        cell.annouce = contents[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let announce = contents[indexPath.row]
        let vc = YSAnnounceDetailViewController()
        vc.announceId = announce.adminnotice_id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
