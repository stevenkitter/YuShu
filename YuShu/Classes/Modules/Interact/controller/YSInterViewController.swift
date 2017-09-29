//
//  YSInterViewController.swift
//  YuShu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSInterViewController: RootViewController {

    var imageList: [Floor] = []
    var head: HeadModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "邻里"
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
        collectionView.register(str: "YSInterCollectionViewCell")
        collectionView.register(UINib(nibName: "YSMoreImageCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "YSMoreImageCollectionReusableView")
        view.addSubview(collectionView)
    }
    
    override func setupRefresh() {
        collectionView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
    }
    
    override func loadServerData() {
        
        NetworkManager.providerCircleApi.request(.getFloorList()).mapArray(Floor.self)
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
        
        
        NetworkManager.providerUserApi.request(.getHeadInfo(type: "user")).mapObject(HeadModel.self).subscribe(onNext: { (info) in
            self.head = info
            self.collectionView.reloadData()
        }, onError: { (err) in
            
        }).addDisposableTo(disposeBag)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    

    

}

extension YSInterViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageM = imageList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSInterCollectionViewCell", for: indexPath) as! YSInterCollectionViewCell
        cell.ys_titleLabel.text = "\(imageM.user_floor ?? "1")号楼"
        cell.numberLabel.text = "-- \(imageM.count ?? "0")人 --"
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
        let floor = imageList[indexPath.item]
        let vc = YSRoomListViewController()
        vc.user_floor = floor.user_floor ?? ""
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension YSInterViewController : YSMoreLayoutDataSource {
    func waterfallLayout(_ layout: YSMoreLayout, indexPath: IndexPath) -> CGFloat {
        return cellWidth(10, 3)
    }
    
    func numberOfColsInWaterfallLayout(_ layout: YSMoreLayout) -> Int {
        return 3
    }
}

