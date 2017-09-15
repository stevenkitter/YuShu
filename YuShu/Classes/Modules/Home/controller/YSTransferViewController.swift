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
    
    let btn = UIButton.buttonWithImage(image: UIImage(named: "tab_willsell")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "闲置转让"
        setupUI()
        setupRefresh()
        loadServerData()
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
       
        self.present(vc, animated: true, completion: nil)
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
}
