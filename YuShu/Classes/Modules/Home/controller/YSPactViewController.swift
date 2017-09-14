//
//  YSPactViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSPactViewController: YSWebViewController {

    override func viewDidLoad() {
        url = WebViewUrl + "convention_display"
        super.viewDidLoad()
        self.title = "小区公约"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
