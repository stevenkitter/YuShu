//
//  YSFitDetailViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/29.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSFitDetailViewController: YSAnnounceDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func setupInit() {
        let req = URLRequest(url: URL(string: webUrl)!)
        webView.load(req)
        
        let block =  { [unowned self] (btn: UIButton) in
            switch btn.tag {
            case 0:
                self.like(btn: btn)
            case 1:
                self.save(btn: btn)
            case 2:
                self.send()
            default:
                return
            }
        }
        commentView.actionBlock = block
        commentView.loadUserInfo(item_id: announceId, type: "guide")
        
    }
    
    override func loadServerData() {
        super.loadServerData()
        guard let userId = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        NetworkManager.providerHomeApi.request(.getCommentList(user_id: userId, type: "guide", item_id: announceId, page: page))
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
