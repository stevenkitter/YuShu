//
//  RootTabBarController.swift
//  InternManager
//
//  Created by apple on 2017/7/31.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit


class RootTabBarController: UITabBarController {
    //控制器的4个自控制器
    public let homeVc = HomeViewController()
    public let interactVc = InteractViewController()
    public let meVc = MeViewController()
    //title image 
    let titles = ["AK网贷","交流","我的"]
    let unSelectedImageStrs = ["home","circle","me"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViewControllers()
    }
    
    func setupChildViewControllers() {
        let subViewControllers = [homeVc,interactVc,meVc];
        var subNaviViewController: [RootNavigationController] = []
        for (index,item) in subViewControllers.enumerated() {
            item.title = titles[index]
            item.tabBarItem.title = titles[index]
            item.tabBarItem.image = UIImage(named: unSelectedImageStrs[index])
            item.tabBarItem.selectedImage = UIImage(named: "\(unSelectedImageStrs[index])_selected")
            let nav = RootNavigationController(rootViewController: item);
            subNaviViewController.append(nav)
        }
        
        setViewControllers(subNaviViewController, animated: true)
    }
    
   

}

extension RootTabBarController {
    
}
