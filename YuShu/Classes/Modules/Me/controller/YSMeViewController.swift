//
//  YSMeViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSMeViewController: RootViewController {
    var contents = [""]
    
    let tableHeader = YSMeHeadView.default()!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        tableView.register(UINib(nibName: "YSHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "YSHomeTableViewCell")
        let headContainer = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: ysMeHeadViewH))
        headContainer.addSubview(tableHeader)
        tableView.tableHeaderView = headContainer
        
        let topImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenWidth * ratio))
        topImageView.image = UIImage(named: "UserHomePageHead_backImg")
        topImageView.contentMode = .scaleAspectFill
        topImageView.tag = 101
        tableView.insertSubview(topImageView, at: 0)
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSHomeTableViewCell", for: indexPath)
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
            rect.size.height = ysMeHeadViewH + space
            tableView.viewWithTag(101)!.frame = rect
        }
    }
}
