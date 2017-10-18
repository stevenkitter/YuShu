//
//  YSMoreViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/7.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import Hero
// 图片的
class YSMoreViewController: RootViewController {
    var imageList: [ImageFile] = []
    var head: HeadModel?
//    var image_package_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "图片展示"
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
        collectionView.register(str: "YSHomeCollectionViewCell")
        collectionView.register(UINib(nibName: "YSMoreImageCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "YSMoreImageCollectionReusableView")
        view.addSubview(collectionView)
    }
    
    override func setupRefresh() {
        collectionView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
    }
    
    override func loadServerData() {
        
        NetworkManager.providerHomeApi.request(.getImageList()).mapArray(ImageFile.self)
            .subscribe(onNext: { [unowned self] (list) in
                if list.count > 0 {
                    self.imageList.removeAll()
                    self.imageList.append(contentsOf: list)
                    self.collectionView.reloadData()
                }
                
                self.collectionView.mj_header.endRefreshing()
                }, onError: { [unowned self] (err) in
                    self.collectionView.mj_header.endRefreshing()
            }).addDisposableTo(disposeBag)
        
        
        NetworkManager.providerUserApi.request(.getHeadInfo(type: "image")).mapObject(HeadModel.self).subscribe(onNext: { (info) in
            self.head = info
            self.collectionView.reloadData()
        }, onError: { (err) in
            
        }).addDisposableTo(disposeBag)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
   

}


extension YSMoreViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageM = imageList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSHomeCollectionViewCell", for: indexPath) as! YSHomeCollectionViewCell
        cell.ys_imageView.kfImage(imageM.image_file_path ?? "")
        cell.ys_titleLabel.text = imageM.image_title ?? ""
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "YSMoreImageCollectionReusableView", for: indexPath) as! YSMoreImageCollectionReusableView
        if let headM = self.head {
            headView.backImageView.kfImage(headM.head_image ?? "")
            headView.closure = { [unowned self] in
                self.webDetail(url: (headM.head_url ?? ""))
            }
        }
        return headView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
       let mo = imageList[indexPath.item]
   
   NetworkManager.providerHomeApi.request(.getImagesByPackageId(image_package_id: mo.image_package_id ?? "")).mapArray(ImageFile.self).subscribe(onNext: { (list) in
            if list.count > 0 {
                var urls: [String] = []
                for item in list {
                    urls.append(item.image_file_path ?? "")
                }
                self.view.showImagesTitle(index: 0, imageUrls: urls, title: list[0].image_title ?? "")
            }
        }, onError: { (err) in
            
        }).addDisposableTo(disposeBag)
    }
}


extension YSMoreViewController : YSMoreLayoutDataSource {
    func waterfallLayout(_ layout: YSMoreLayout, indexPath: IndexPath) -> CGFloat {
        return CGFloat(arc4random_uniform(80)) + cellWidth(10, 3) + 40
    }
    
    func numberOfColsInWaterfallLayout(_ layout: YSMoreLayout) -> Int {
        return 3
    }
}



//视频的
class YSMoreVideoViewController: RootViewController {
    
    var videoList: [VideoFile] = []
    var head: HeadModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "视频展示"
        setupUI()
        setupRefresh()
        collectionView.mj_header.beginRefreshing()
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
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.register(str: "YSHomeCollectionViewCell")
        collectionView.register(UINib(nibName: "YSMoreImageCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "YSMoreImageCollectionReusableView")
        view.addSubview(collectionView)
    }
    
    override func setupRefresh() {
        collectionView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
    }
    
    override func loadServerData() {
        
        NetworkManager.providerHomeApi.request(.getVideoList()).mapArray(VideoFile.self)
            .subscribe(onNext: { [unowned self] (list) in
                if list.count > 0 {
                    self.videoList.removeAll()
                    self.videoList.append(contentsOf: list)
                    self.collectionView.reloadData()
                }
                
                self.collectionView.mj_header.endRefreshing()
                }, onError: { [unowned self] (err) in
                    self.collectionView.mj_header.endRefreshing()
            }).addDisposableTo(disposeBag)
        
        
        NetworkManager.providerUserApi.request(.getHeadInfo(type: "video")).mapObject(HeadModel.self).subscribe(onNext: { (info) in
            self.head = info
            self.collectionView.reloadData()
        }, onError: { (err) in
            
        }).addDisposableTo(disposeBag)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}


extension YSMoreVideoViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageM = videoList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSHomeCollectionViewCell", for: indexPath) as! YSHomeCollectionViewCell
        cell.ys_imageView.kfImage(imageM.video_logo_path ?? "")
        cell.ys_titleLabel.text = imageM.video_title ?? ""
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "YSMoreImageCollectionReusableView", for: indexPath) as! YSMoreImageCollectionReusableView
        if let headM = self.head {
            headView.backImageView.kfImage(headM.head_image ?? "")
            headView.closure = { [unowned self] in
                self.webDetail(url: (headM.head_url ?? ""))
            }
        }
        return headView
    }
    
}


extension YSMoreVideoViewController : YSMoreLayoutDataSource {
    func waterfallLayout(_ layout: YSMoreLayout, indexPath: IndexPath) -> CGFloat {
        return CGFloat(arc4random_uniform(80)) + cellWidth(10, 2) + 40
    }
    
    func numberOfColsInWaterfallLayout(_ layout: YSMoreLayout) -> Int {
        return 2
    }
}

