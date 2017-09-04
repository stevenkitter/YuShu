//
//  RootViewController.swift
//  InternManager
//
//  Created by apple on 2017/7/31.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class RootViewController: UIViewController {
    let disposeBag = DisposeBag()
    let tableView = UITableView(frame: CGRect.zero, style: .plain).then {
        $0.estimatedRowHeight = 50
        $0.tableFooterView = UIView()
    }
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setupRefresh() {
        tableView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
        tableView.mj_footer = RefreshFooter(refreshingBlock: {
            [unowned self] in
            self.loadServerData()
        })
    }
    
    func loadServerData() {
        if tableView.mj_header.isRefreshing() {
            page = 1
            tableView.mj_footer.resetNoMoreData()
        }
    }

    func hideNavigationBar() {
        
        self.navigationController?.setNavigationBarHidden(self.tableView.mj_offsetY <= 150, animated: true)
        
    }

}
