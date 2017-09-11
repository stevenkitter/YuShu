//
//  YSAnnounceViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSAnnounceViewController: RootViewController {
    var contents: [Announce] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "群主公告"
        setupUI()
        setupRefresh()
    }
    
    override func loadServerData() {
        super.loadServerData()
        
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 48, 0))
        }
        tableView.register(UINib(nibName: "YSHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "YSHomeTableViewCell")
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
        
    }
}
