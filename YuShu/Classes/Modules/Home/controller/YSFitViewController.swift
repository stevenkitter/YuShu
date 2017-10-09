//
//  YSFitViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSFitViewController: RootViewController {

    var contents: [YSMeHeadViewCellM] = [YSMeHeadViewCellM(image: "辅材商店", title: "辅材商店", num: "装修辅材 泥沙 砖瓦"), YSMeHeadViewCellM(image: "装修配套", title: "装修配套", num: "配套材料 吊灯 沙发")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "全部分类"
        
        setupUI()
    }

    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        tableView.register(str: "YSFitmentTableViewCell")
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.separatorStyle = .singleLine
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

  
}
extension YSFitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let con = contents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSFitmentTableViewCell", for: indexPath) as! YSFitmentTableViewCell
        cell.iconImageView.image = UIImage(named: con.image)
        cell.ys_titleLabel.text = con.title
        cell.contentLabel.text = con.num
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = YSFitmentMainViewController()
        switch contents[indexPath.row].title {
        case "辅材商店":
            vc.type = 1
        case "装修配套":
            vc.type = 2
        default:
            vc.type = 1
        }
        vc.title = contents[indexPath.row].title
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



