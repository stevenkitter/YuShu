//
//  YSMYCollectViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/29.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSMYCollectViewController: RootViewController {

    var contents: [MYCollect] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefresh()
        loadServerData()
        title = "我的收藏"
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(str: "YSMYCollectTableViewCell")
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    override func loadServerData() {
        super.loadServerData()
        guard  let userId = UserManager.shareUserManager.curUserInfo?.user_id else {
            return
        }
        NetworkManager.providerUserApi.request(.getMyCollection(user_id: userId, page: page)).mapArray(MYCollect.self).subscribe(onNext: { (list) in
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

extension YSMYCollectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = contents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSMYCollectTableViewCell", for: indexPath) as! YSMYCollectTableViewCell
        cell.ys_titleLabel.text = model.collection_title
        cell.iconImageView.kfImage(model.collection_image ?? "")
        cell.timeLabel.text = (model.collection_addtime ?? "").timeAgo()
        cell.categoryLabel.text = " " + (model.collection_type ?? "").categoryStr() + " "
        cell.categoryLabel.backgroundColor = (model.collection_type ?? "").categoryColor()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = contents[indexPath.row]
        var vc: RootViewController? = nil
        switch model.collection_type ?? "" {
        case "adminnotice":
            vc = YSAnnounceDetailViewController()
//            vc.announceId = model.collection_id ?? ""
        case "post":
            vc = YSPostSuggestDetailViewController()
//            vc.announceId = model.collection_id ?? ""
        case "transfer":
            vc = YSTransferDetailViewController()
        case "guide":
            vc = YSFitDetailViewController()
        default:
            vc = YSFitDetailViewController()
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
 
