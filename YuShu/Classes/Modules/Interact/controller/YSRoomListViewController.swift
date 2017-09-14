//
//  YSRoomListViewController.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/14.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import EasyTipView
class YSRoomListViewController: RootViewController {

    var roomList: [Room] = []
    var user_floor = ""
    
    let popView = YSUserListView(frame: KScreenBounds)
    
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
        collectionView.register(str: "YSRoomCollectionViewCell")
        collectionView.register(UINib(nibName: "YSMoreImageCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "YSMoreImageCollectionReusableView")
        view.addSubview(collectionView)
    }
    
    override func setupRefresh() {
        collectionView.mj_header = RefreshHeader(refreshingBlock: { [unowned self] in
            self.loadServerData()
        })
    }
    
    override func loadServerData() {
        
        NetworkManager.providerCircleApi.request(.getRoomList(user_floor: user_floor)).mapArray(Room.self)
            .subscribe(onNext: { [unowned self] (list) in
                if list.count > 0 {
                    self.roomList.removeAll()
                    self.roomList.append(contentsOf: list)
                    self.collectionView.reloadData()
                }
                
                self.collectionView.mj_header.endRefreshing()
                }, onError: { [unowned self] (err) in
                    self.collectionView.mj_header.endRefreshing()
            }).addDisposableTo(disposeBag)
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
    
    
    


}

extension YSRoomListViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let room = roomList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSRoomCollectionViewCell", for: indexPath) as! YSRoomCollectionViewCell
        cell.statusBtn.isSelected = room.activate_count != "0"
        cell.roomLabel.text = room.user_room ?? ""
        cell.memberBtn.setTitle("\(room.activate_count ?? "0")/\(room.user_count ?? "0")", for: .normal)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "YSMoreImageCollectionReusableView", for: indexPath)
        return headView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let room = roomList[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath)
        guard let cellF = cell?.frame else {return}
        var x: CGFloat = 0
        var y: CGFloat = 0
        if cellF.maxY > KScreenHeight / 2 {
            y = cellF.minY
        }else{
            y = cellF.maxY
        }
        
        if cellF.maxX > KScreenWidth / 2 {
            x = cellF.maxX
        }else{
            x = cellF.minX
        }
        
        WXActivityIndicatorView.start()
        NetworkManager.providerCircleApi.request(.getUserList(user_floor: user_floor, user_room: room.user_room ?? "")).mapArray(PraiseUser.self).subscribe(onNext: { (list) in
            WXActivityIndicatorView.stop()
            self.popView.users = list
            self.view.addSubview(self.popView)
            self.popView.show(point: CGPoint(x: x, y: y))
        }, onError: { (err) in
            WXActivityIndicatorView.stop()
        }).addDisposableTo(disposeBag)
    }
}


extension YSRoomListViewController : YSMoreLayoutDataSource {
    func waterfallLayout(_ layout: YSMoreLayout, indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func numberOfColsInWaterfallLayout(_ layout: YSMoreLayout) -> Int {
        return 2
    }
}
