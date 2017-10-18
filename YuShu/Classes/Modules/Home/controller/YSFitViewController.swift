//
//  YSFitViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import LLCycleScrollView
class YSFitViewController: RootViewController {
    var contents: [PostSuggest] = []
//    var contents: [YSMeHeadViewCellM] = [YSMeHeadViewCellM(image: "辅材商店", title: "辅材商店", num: "装修辅材 泥沙 砖瓦"), YSMeHeadViewCellM(image: "装修配套", title: "装修配套", num: "配套材料 吊灯 沙发")]
    var slides: [Slide] = []
    let footer = YSNextPageView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 50))
    
    let btn = UIButton.buttonWithImage(image: UIImage(named: "tab_willsell")!)
    let btns = YSThreeBtns.default()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "装修指南"
        
        setupUI()
        setupRefresh()
        setupRx()
        tableView.mj_header.beginRefreshing()
    }

    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        tableView.register(str: "AnnounceTableViewCell")
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = footer
        
        footer.delegate = self
        
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(addTransfer), for: .touchUpInside)
        btn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20)
            make.bottom.equalTo(self.view).offset(-50)
            
        }
        
        setupHeader()
        
        btns.closure = {btn in
            if btn.tag == 0 {
                let vc = YSFitmentMainViewController()
                vc.type = 1
                vc.title = "辅材商店"
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = YSFitmentMainViewController()
                vc.type = 2
                vc.title = "装修配套"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func addTransfer() {
        let vc = YSTransferAddViewController()
        vc.postWhat = 3
        self.present(vc, animated: true, completion: nil)
    }
    func setupRx() {
        NotificationCenter.default.rx.notification(NotifyCircleAdded).subscribe(onNext: { [unowned self] (_) in
            self.tableView.mj_header.beginRefreshing()
            
            }, onError: { (err) in
                
        }).addDisposableTo(disposeBag)
    }
    
    
    
    func setupHeader() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 160+50))
        let adView = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect(x: 0, y: 0, width: KScreenWidth, height: 160), didSelectItemAtIndex: { [unowned self] (index) in
            
            let ad = self.slides[index]
            let vc = YSWebViewController()
            vc.url = WebUrl + (ad.slide_id ?? "")
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        adView.autoScroll = true
        adView.autoScrollTimeInterval = 4.0
        adView.customPageControlStyle = .snake
        adView.titleBackgroundColor = UIColor.clear
        
        container.addSubview(adView)
        
        btns.frame = CGRect(x: 0, y: 160, width: KScreenWidth, height: 50)
        container.addSubview(btns)
        
        tableView.tableHeaderView = container
    }
    override func setupRefresh() {
        tableView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
    }
    
    override func loadServerData() {
        NetworkManager.providerHomeApi.request(.postInfo(page: page, post_type: "3")).mapObject(PostSuggestInfo.self).subscribe(onNext: { (info) in
            self.contents.removeAll()
            
            self.contents.append(contentsOf: info.list)
            
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            
            if let myPage = Int(info.page_count ?? "") {
                self.footer.allPage = myPage
            }
            
            
            self.footer.page = self.page
            
        }, onError: { (err) in
            self.tableView.mj_header.endRefreshing()
            
        }).addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

  
}

extension YSFitViewController: YSNextPageViewDelegate {
    func forward() {
        page -= 1
        loadServerData()
    }
    func nextPage() {
        page += 1
        loadServerData()
    }
    func go(page: Int) {
        self.page = page
        loadServerData()
    }
    
}

extension YSFitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mo = contents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnounceTableViewCell", for: indexPath) as! AnnounceTableViewCell
        cell.ys_titleLabel.text = mo.post_title
        cell.timeLabel.text = (mo.post_addtime ?? "").timeStr()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tr = contents[indexPath.row]
        let vc = YSPostSuggestDetailViewController()
        vc.postSuggest = tr
        vc.transferId = tr.post_id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

class YSFitmentMainViewController: RootViewController {
    var type = 1
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadServerData()
        
    }
    
    override func loadServerData() {
        NetworkManager.providerHomeApi.request(.fitmentTags(category: type)).mapArray(FitmentType.self).subscribe(onNext: { (list) in
            self.setupUI(list: list)
        }, onError: { (err) in
            
        }).addDisposableTo(disposeBag)
    }
    
    func setupUI(list: [FitmentType]) {
        var vcs: [RootViewController] = []
        
        for item in list {
            let vc = YSFitmentViewController()
            vc.guide_type_id = item.guide_type_id ?? ""
            vc.title = item.guide_type_value ?? ""
            vc.parentVc = self
            vcs.append(vc)
        }
        
        pageMenu = CAPSPageMenu(viewControllers: vcs, frame: self.view.bounds, pageMenuOptions: pageParameters)
        
        view.addSubview(pageMenu!.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

class YSFitmentViewController: RootViewController {
    var contents: [Announce] = []
    var parentVc: RootViewController?
    var guide_type_id = ""
   
    var fitments: [Fitment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefresh()
        loadServerData()
    }
 
    override func loadServerData() {
        if collectionView.mj_header.isRefreshing() {
            page = 1
            collectionView.mj_footer.resetNoMoreData()
        }
//        guard let user_id = UserManager.shareUserManager.curUserInfo?.user_id else {return}
        NetworkManager.providerHomeApi.request(.fitmentList(page: page, guide_type_id: guide_type_id)).mapObject(FitmentData.self).subscribe(onNext: { (info) in
            if self.page == 1 {
                self.fitments.removeAll()
            }
            self.fitments.append(contentsOf: info.list)
            self.page += 1
            self.collectionView.reloadData()
            self.collectionView.mj_header.endRefreshing()
            if info.list.count < pageNum {
                self.collectionView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.collectionView.mj_footer.endRefreshing()
            }

        }, onError: { (err) in
            self.collectionView.mj_header.endRefreshing()
            self.collectionView.mj_footer.endRefreshing()
        }).addDisposableTo(disposeBag)
    }
    
    
    func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (KScreenWidth - 5) * 0.5, height: (KScreenWidth - 5) * 0.5 + 60)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.isUserInteractionEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        collectionView.register(str: "YSFitmentCollectionViewCell")
        collectionView.corner()
        
        view.addSubview(collectionView)
    }
    override func setupRefresh() {
        collectionView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
        collectionView.mj_footer = RefreshFooter(refreshingBlock: {
            [unowned self] in
            self.loadServerData()
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}



extension YSFitmentViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fitments.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSFitmentCollectionViewCell", for: indexPath) as! YSFitmentCollectionViewCell
        cell.fitment = fitments[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fit = fitments[indexPath.item]
        let vc = YSAnnounceDetailViewController()
        vc.announceId = fit.guide_id ?? ""
        vc.webUrl = GuideUrl + (fit.guide_id ?? "")
        vc.type = "guide"
        parentVc?.navigationController?.pushViewController(vc, animated: true)
        
    }
}



