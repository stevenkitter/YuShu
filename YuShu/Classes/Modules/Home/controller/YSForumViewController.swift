//
//  YSForumViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSForumViewController: RootViewController {
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "邻里发布"
        setupUI()
        // Do any additional setup after loading the view.
    }

    func setupUI() {
        let vc0 = YSNewCirclesViewController()
        vc0.title = "最新动态"
        vc0.parentVc = self
        let vc1 = YSTransferViewController()
        vc1.title = "闲置转让"
        vc1.parentVc = self
        let vc2 = YSSuggestsViewController()
        vc2.title = "公共建议"
        vc2.parentVc = self
        
        let vcs = [vc0, vc1, vc2]
    
        pageMenu = CAPSPageMenu(viewControllers: vcs, frame: self.view.bounds, pageMenuOptions: pageParameters)
        view.addSubview(pageMenu!.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
