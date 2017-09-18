//
//  YSUserListView.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/14.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import pop
let YSUserListViewCellW: CGFloat = 65

class YSUserListView: UIView {
    
    var users: [PraiseUser] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    var bg: UIView!
    var collectionView: UICollectionView!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBg()
        setupCollectionView()
        self.backgroundColor = UIColor.clear
    }
    
    func setupBg() {
        bg = UIView(frame: self.bounds)
        bg.backgroundColor = UIColor.flatGray.alpha(0.6)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        tap.delegate = self
        bg.addGestureRecognizer(tap)
        self.addSubview(bg)
    }
   
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: YSUserListViewCellW, height: YSUserListViewCellW)
        let rect = CGRect(x: 0, y: 0, width: KScreenWidth - 40, height: YSUserListViewCellW)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.isUserInteractionEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.register(str: "YSRoomUserCollectionViewCell")
        collectionView.corner()
        
        bg.addSubview(collectionView)
        
        imageView = UIImageView(frame: CGRect.zero)
        
        bg.addSubview(imageView)
    }
    
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(point: CGPoint, cell: UICollectionViewCell?) {
        guard self.superview != nil else {
            
            return
        }
        guard users.count > 0 else {return}
        
        guard let cellItem = cell else {return}
        
        let imageV = cellItem.createImageView()
        imageView.image = imageV.image
        imageView.frame = imageV.frame
        imageView.moveY(y: 64)
        
        
        
        let wi = min(userHeadWidth(0,CGFloat(users.count),YSUserListViewCellW), KScreenWidth - 40)
        var x: CGFloat = 0
       
        if point.x > KScreenWidth / 2 {
            x = point.x - 10 - wi
        }else{
            x = point.x + 10
        }
        
        let rect = point.y < KScreenHeight / 2 ? CGRect(x: x, y: imageView.frame.maxY - YSUserListViewCellW, width: wi, height: YSUserListViewCellW) : CGRect(x: x, y: imageView.frame.minY + YSUserListViewCellW, width: wi, height: YSUserListViewCellW)

        
        self.collectionView.frame = rect
        
        if let aim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY) {
            aim.toValue = point.y < KScreenHeight / 2 ? imageView.frame.maxY + 10 + YSUserListViewCellW * 0.5  : imageView.frame.minY - 10 - YSUserListViewCellW * 0.5
            collectionView.layer.pop_add(aim, forKey: "moveY")
        }
       
    }
    
    func hide() {
        self.removeFromSuperview()
    }
    
}

extension YSUserListView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let inCol = collectionView.frame.contains(touch.location(in: bg))
        return !inCol
    }
}

extension YSUserListView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let user = users[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSRoomUserCollectionViewCell", for: indexPath) as! YSRoomUserCollectionViewCell
        cell.user = user
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let superV = self.superVc() as? RootViewController else {
            return
        }
        guard let userId = users[indexPath.item].user_id else {return}
        self.hide()
        let vc = YSPersonalViewController()
        vc.userId = userId
        superV.navigationController?.pushViewController(vc, animated: true)
        
    }
}
