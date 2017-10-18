//
//  YSRimViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import LLCycleScrollView
class YSRimViewController: RootViewController {

    var infos: [AroundInfo] = []
    var slides: [Slide] = []
    var head: HeadModel?
    //    var image_package_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "周边便民"
        setupUI()
        setupRefresh()
        loadServerData()
    }
    
    func setupUI() {
        // 1.设置布局
        let layout = YSMoreLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.dataSource = self
        // 2.创建UICollectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.register(str: "YSHomeEightCollectionViewCell")
        collectionView.register(UINib(nibName: "YSMoreImageCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "YSMoreImageCollectionReusableView")
        view.addSubview(collectionView)
    }
    
    override func setupRefresh() {
        collectionView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
    }
    
    override func loadServerData() {
        
        NetworkManager.providerCircleApi.request(.getAroundTypes()).mapArray(AroundInfo.self)
            .subscribe(onNext: { [unowned self] (list) in
                if list.count > 0 {
                    self.infos.removeAll()
                    self.infos.append(contentsOf: list)
                    self.collectionView.reloadData()
                }
                
                self.collectionView.mj_header.endRefreshing()
                }, onError: { [unowned self] (err) in
                    self.collectionView.mj_header.endRefreshing()
            }).addDisposableTo(disposeBag)
        
        
        NetworkManager.providerCircleApi.request(.getAroundSlids()).mapArray(Slide.self).subscribe(onNext: { (list) in
            if list.count > 0 {
                self.slides.removeAll()
                self.slides.append(contentsOf: list)
                self.collectionView.reloadData()
            }
        }, onError: { (err) in
            
        }).addDisposableTo(disposeBag)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension YSRimViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageM = infos[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSHomeEightCollectionViewCell", for: indexPath) as! YSHomeEightCollectionViewCell
        cell.ys_titleLabel.text = imageM.around_type_value
        cell.ys_imageView.kfImage(imageM.around_type_image_path ?? "")
        cell.ys_imageView.cornerRadius(width: 35)
        cell.ys_titleLabel.font = UIFont.systemFont(ofSize: 12)
        cell.contentView.backgroundColor = .white
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "YSMoreImageCollectionReusableView", for: indexPath) as! YSMoreImageCollectionReusableView
        if let ad = headView.viewWithTag(101) as? LLCycleScrollView {
            var images:[String] = []
            for item in slides {
                images.append(item.slide_image_path ?? "")
            }
            ad.imagePaths = images
        }else{
            let adView = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect(x: 0, y: 0, width: KScreenWidth, height: headView.frame.height), didSelectItemAtIndex: { [unowned self] (index) in
                
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
            
            headView.addSubview(adView)
            adView.tag = 101
            var images:[String] = []
            for item in slides {
                images.append(item.slide_image_path ?? "")
            }
            adView.imagePaths = images
        }
        
        return headView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = infos[indexPath.item]
        let vc = YSRimentViewController()
        vc.around_type_id = model.around_type_id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension YSRimViewController : YSMoreLayoutDataSource {
    func waterfallLayout(_ layout: YSMoreLayout, indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellWidth(10, 4))
    }
    
    func numberOfColsInWaterfallLayout(_ layout: YSMoreLayout) -> Int {
        return 4
    }
}


class YSRimentViewController: RootViewController {
    var contents: [AroundDetailInfo] = []
    var parentVc: RootViewController?
    var around_type_id = ""
    
 
    
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
        NetworkManager.providerCircleApi.request(.getAroundInfo(page: page, around_type_id: around_type_id)).mapArray(AroundDetailInfo.self).subscribe(onNext: { (list) in
            if self.page == 1 {
                self.contents.removeAll()
            }
            self.contents.append(contentsOf: list)
            self.page += 1
            self.collectionView.reloadData()
            self.collectionView.mj_header.endRefreshing()
            if list.count < pageNum {
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
        collectionView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
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



extension YSRimentViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSFitmentCollectionViewCell", for: indexPath) as! YSFitmentCollectionViewCell
        let model = contents[indexPath.item]
        cell.iconImageView.kfImageNormal(model.around_image_path ?? "")
        cell.contentLabel.text = model.around_title ?? ""
        cell.addTimeLabel.text = (model.around_addtime ?? "").timeAgo()
        cell.favourBtn.setTitle(model.around_praise_count ?? "", for: .normal)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fit = contents[indexPath.item]
        let vc = YSAnnounceDetailViewController()
        vc.announceId = fit.around_id ?? ""
        vc.webUrl = AroundUrl + (fit.around_id ?? "")
        vc.type = "around"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


