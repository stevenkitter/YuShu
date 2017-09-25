//
//  YSAnnounceMainViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/25.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
let pageParameters: [CAPSPageMenuOption] = [
    .scrollMenuBackgroundColor(UIColor.white),
    .viewBackgroundColor(UIColor.groupTableViewBackground),
    .selectionIndicatorColor(KNaviColor),
    .selectedMenuItemLabelColor(KNaviColor),
    .bottomMenuHairlineColor(UIColor.white),
    .menuItemFont(UIFont.systemFont(ofSize: 14)),
    .menuHeight(45.0),
    .menuItemWidthBasedOnTitleTextWidth(true),
    .centerMenuItems(true)
]
class YSAnnounceMainViewController: RootViewController {

    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "群主公告"
        setupUI()
        
    }
    
    func setupUI() {
        let vc0 = YSAnnounceViewController()
        vc0.title = "最新通知"
        let vc1 = YSCivilViewController()
        vc1.title = "民政汇总"
        
        let vcs = [vc0, vc1]
        
        vc0.parentVc = self
        vc1.parentVc = self

        pageMenu = CAPSPageMenu(viewControllers: vcs, frame: self.view.bounds, pageMenuOptions: pageParameters)
        
        view.addSubview(pageMenu!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
