//
//  YSPersonalViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/18.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSPersonalViewController: RootViewController {
    var userId = ""
    
    var user: UserInfo? {
        didSet{
            setupInit()
        }
    }
    fileprivate var showContents: [ShowContent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "用户详情"
        setupUI()
        setupRefresh()
        loadServerData()
    }
    
    func setupUI() {
        tableViewGrouped.delegate = self
        tableViewGrouped.dataSource = self
        
        self.view.addSubview(self.tableViewGrouped)
        tableViewGrouped.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        tableViewGrouped.register(str: "YSPersonalTableViewCell")
        tableViewGrouped.register(str: "YSEditMeTableViewCell")
     
        tableViewGrouped.backgroundColor = UIColor.groupTableViewBackground
        
        
    }
    
    override func setupRefresh() {
        tableViewGrouped.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
    }
    
    override func loadServerData() {
        
        NetworkManager.providerUserApi.request(.userInfo(user_id: userId)).mapObject(UserInfo.self).subscribe(onNext: { (info) in
            self.user = info
            
            self.tableViewGrouped.mj_header.endRefreshing()
        }, onError: { (err) in
            self.tableViewGrouped.mj_header.endRefreshing()
        }).addDisposableTo(disposeBag)
    }
    
    func setupInit() {
        showContents.removeAll()
        let trueName = ShowContent(title: "真实姓名", detail: user?.user_name_set == "1" ? (user?.user_name ?? ""):"保密")
        let truePhone = ShowContent(title: "手机号", detail: user?.user_tel_set == "1" ? (user?.user_tel ?? ""):"**")
        let trueBirth = ShowContent(title: "出生日期", detail: user?.user_birthday_set == "1" ? (user?.user_birthday ?? ""):"保密")
        showContents.append(contentsOf: [trueName, truePhone, trueBirth])
        tableViewGrouped.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}
extension YSPersonalViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : showContents.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 90 : 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YSPersonalTableViewCell", for: indexPath) as! YSPersonalTableViewCell
            cell.iconImageView.kfImage(user?.user_headpic ?? "")
            let normalSex = user?.user_sex == "2" ? "🙎🏻" : "🙎🏻‍♂️"
            let sex = user?.user_sex == "3" ? "保密" : normalSex
            cell.nameLabel.text = "\(user?.user_floor ?? "")栋\(user?.user_room ?? "")\(user?.user_no ?? "") \(sex)"
            cell.midLabel.text = "昵称: \(user?.user_nickname ?? "")"
            cell.bottomLabel.text = ""
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YSEditMeTableViewCell", for: indexPath) as! YSEditMeTableViewCell
            let content = showContents[indexPath.row]
            cell.ys_titleLabel.text = content.title
            cell.detailLabel.text = content.detail
            cell.selectionStyle = .none
            cell.accessoryType = .none
            return cell
        }
    }
}

struct ShowContent {
    var title = ""
    var detail = ""
}
