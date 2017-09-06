//
//  YSHomeViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import SnapKit
class YSHomeViewController: RootViewController {
    
    let contents: [[String]] = []
    var timer: DispatchSourceTimer?
    let tableHeader = YSHomeHeadView.default()!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefresh()
        tableView.mj_header.beginRefreshing()
    }
    
    func setupUI() {
        self.tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        tableView.register(UINib(nibName: "YSHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "YSHomeTableViewCell")
        let headContainer = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 320))
        headContainer.addSubview(tableHeader)
        tableView.tableHeaderView = headContainer
    }
    
    override func setupRefresh() {
        tableView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
    }
    
    override func loadServerData() {
        
        tableHeader.notices = ["小区消息发过来了","小区消息发过来了","小区消息发过来了","小区消息发过来了","小区消息发过来了"]
        tableView.mj_header.endRefreshing()
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
//MARK: tableview
extension YSHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSHomeTableViewCell", for: indexPath)
        return cell
    }
}
