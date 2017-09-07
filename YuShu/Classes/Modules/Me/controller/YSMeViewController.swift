//
//  YSMeViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSMeViewController: RootViewController {
    
    let contents = [YSMeHeadViewCellM(image: "send_normal", title: "联系客服", num: "2"),YSMeHeadViewCellM(image: "send_normal", title: "提出意见", num: "2"), YSMeHeadViewCellM(image: "send_normal", title: "关于御墅社区", num: "2"),
                 YSMeHeadViewCellM(image: "send_normal", title: "给个好评吧", num: "2")]
    let tableHeader = YSMeHeadView.default()!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.clear.createImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIColor.clear.createImage()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(KNaviColor.createImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        tableView.register(str: "YSMeTableViewCell")
        let headContainer = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: ysMeHeadViewH))
        headContainer.addSubview(tableHeader)
        tableView.tableHeaderView = headContainer
        
        let topImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenWidth * ratio))
        topImageView.image = UIImage(named: "UserHomePageHead_backImg")
        topImageView.contentMode = .scaleAspectFill
        topImageView.tag = 101
        tableView.insertSubview(topImageView, at: 0)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "设置"), style: .plain, target: self, action: #selector(setting))
    }
    
    func setting() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
}
//MARK: tableview
extension YSMeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = contents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSMeTableViewCell", for: indexPath) as! YSMeTableViewCell
        cell.ys_imageView.image = UIImage(named: model.image)
        cell.ys_titleLabel.text = model.title
        cell.ys_detailLabel.text = ""
        return cell
    }
}

extension YSMeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        print(point.y)
        let space = -point.y
        if space > 0 {
            var rect = tableView.viewWithTag(101)!.frame
            rect.origin.y = -space
            rect.size.height = KScreenWidth * ratio + space
            tableView.viewWithTag(101)!.frame = rect
        }
    }
}
