//
//  YSEditPrivacySettingViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSEditPrivacySettingViewController: RootViewController {
    var contents: [YSMeHeadViewCellM] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupCellM()
    }

    func setupUI() {
        self.title = "隐私设置"
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        tableView.register(str: "YSEditPrivacyTableViewCell")
       
    }
    
    func setupCellM() {
        contents.removeAll()
        
        guard let user = UserManager.shareUserManager.curUserInfo else {return}
        
        
        let name = YSMeHeadViewCellM(image: "user_name_set", title: "允许别人查看我的真实姓名", num: user.user_name_set ?? "")
        contents.append(name)
        
        
        let tel = YSMeHeadViewCellM(image: "user_tel_set", title: "允许别人查看我的手机", num: user.user_tel_set ?? "")
        contents.append(tel)
        
        let birth = YSMeHeadViewCellM(image: "user_birthday_set", title: "允许别人查看我的出生年月", num: user.user_birthday_set ?? "")
        contents.append(birth)
        
        
        tableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

extension YSEditPrivacySettingViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = contents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSEditPrivacyTableViewCell", for: indexPath) as! YSEditPrivacyTableViewCell
        cell.ys_titleLabel.text = model.title
        cell.switch.isOn = model.num == "1" ? true : false
        cell.sure = { [unowned self] isOn in
            let intOn = isOn ? 1 : 0
            self.changePrivacy(str: model.image, isOn: "\(intOn)")
        }
        return cell
    }
}
extension YSEditPrivacySettingViewController {
    func changePrivacy(str: String, isOn: String) {
        changeInfo(key: str, str: isOn)
    }
}
