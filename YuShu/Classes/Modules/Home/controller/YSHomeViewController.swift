//
//  YSHomeViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import SnapKit
let ratio: CGFloat = 2/5
class YSHomeViewController: RootViewController {
    
    var homeInfo: HomeInfo? = nil {
        didSet{
            reSetupUI()
        }
    }
    var timer: DispatchSourceTimer?
    let tableHeader = YSHomeHeadView.default()!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefresh()
        tableView.mj_header.beginRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(KNaviColor.createImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    func setupUI() {
        self.tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 48, 0))
        }
        tableView.register(UINib(nibName: "YSHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "YSHomeTableViewCell")
        let headContainer = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenWidth * ratio + 60 + itemW * 2 + 30 + 20))
        headContainer.addSubview(tableHeader)
        tableHeader.snp.makeConstraints { (make) in
            make.edges.equalTo(headContainer)
        }
        tableView.tableHeaderView = headContainer
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func setupRefresh() {
        tableView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
    }
    
    override func loadServerData() {
        
        NetworkManager.providerHomeApi.request(.homeInfo()).mapObject(HomeInfo.self)
        .subscribe(onNext: { [unowned self] (info) in
            self.homeInfo = info
            
            self.tableView.mj_header.endRefreshing()
            }, onError: { [unowned self] (err) in
            self.tableView.mj_header.endRefreshing()
        }).addDisposableTo(disposeBag)
        
        
        
        
        
    }
    
    func reSetupUI(){
        guard let info = homeInfo else {return}
       
        tableHeader.ads = info.slidelist
        var broadStr = ""
        for item in info.broadcastlist {
            broadStr += "      \(item.broadcast_title ?? "")"
        }
        tableHeader.noticeStr = broadStr
        tableView.reloadData()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
//MARK: tableview
extension YSHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let vc = YSMoreViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = YSMoreVideoViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSHomeTableViewCell", for: indexPath) as! YSHomeTableViewCell
        if indexPath.section == 0 {
            cell.titleLabel.text = "图片分享"
            cell.models = homeInfo?.imageList ?? []
        }else{
            cell.titleLabel.text = "视频分享"
            cell.models = homeInfo?.videoList ?? []
        }
        return cell
    }
}

extension YSHomeViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
}
