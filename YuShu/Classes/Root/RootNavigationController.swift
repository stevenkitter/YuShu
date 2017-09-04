//
//  RootNavigationController.swift
//  InternManager
//
//  Created by apple on 2017/7/31.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        customUI()
        // Do any additional setup after loading the view.
    }
    
    func customUI() -> Void {
        navigationBar.barTintColor = KNaviColor
        navigationBar.tintColor = KTintColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:KTintColor]
    }
    
    override var childViewControllerForStatusBarStyle: UIViewController?{
        return topViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
