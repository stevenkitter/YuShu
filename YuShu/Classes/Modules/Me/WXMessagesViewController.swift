//
//  WXMessagesViewController.swift
//  InternManager
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class WXMessagesViewController: RootViewController {
    let titles = ["提到我的","评论","推送文章"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    func setupUI(){
        self.title = "消息"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0,0, 0))
        }
        tableView.register(str: "MeTableViewCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}

extension WXMessagesViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let str = titles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeTableViewCell", for: indexPath) as! MeTableViewCell
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.iconImageView.image = UIImage(named: str)
        cell.titleLabel.text = str
        cell.titleLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = WXMessageListViewController()
            vc.wxIsComment = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1{
            let vc = WXMessageListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = WXPushedArticleViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
