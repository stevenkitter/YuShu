//
//  YSUserListView.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/14.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
let YSUserListViewCellW: CGFloat = 85
class YSUserListView: UIView {
    var users: [PraiseUser] = [] {
        didSet{
            collectionView.setwidth(w: userHeadWidth(-10,CGFloat(users.count),YSUserListViewCellW))
            collectionView.reloadData()
        }
    }
    
    var bg: UIView!
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBg()
        setupCollectionView()
        self.backgroundColor = UIColor.clear
    }
    
    func setupBg() {
        bg = UIView(frame: self.bounds)
        bg.backgroundColor = UIColor.lightGray.alpha(0.2)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        bg.addGestureRecognizer(tap)
        self.addSubview(bg)
    }
   
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: YSUserListViewCellW, height: YSUserListViewCellW)
        let rect = CGRect(x: 0, y: 0, width: KScreenWidth - 40, height: YSUserListViewCellW)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.register(str: "YSHomeEightCollectionViewCell")
        collectionView.register(UINib(nibName: "YSMoreImageCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "YSMoreImageCollectionReusableView")
        bg.addSubview(collectionView)
    }
    
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(point: CGPoint) {
        guard users.count > 0 else {return}
        guard let win = UIApplication.shared.keyWindow else {return}
        win.addSubview(self)
        let wi = userHeadWidth(-10,CGFloat(users.count),YSUserListViewCellW)
        var x: CGFloat = 0
        var y: CGFloat = 0
        if point.y > KScreenHeight / 2 {
            y = point.y - 10 - wi
        }else{
            y = point.y + 10
        }
        if point.x > KScreenWidth / 2 {
            x = point.x - 10 - wi
        }else{
            x = point.x + 10
        }
        let rect = CGRect(x: x, y: y + 64, width: wi, height: YSUserListViewCellW)
        UIView.animate(withDuration: 0.5, animations: {
            self.collectionView.frame = rect
        }, completion: nil)
    }
    
    func hide() {
        self.removeFromSuperview()
    }

}

extension YSUserListView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let user = users[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSHomeEightCollectionViewCell", for: indexPath) as! YSHomeEightCollectionViewCell
        cell.ys_imageView.cornerRadius(width: 35)
        cell.ys_imageView.kfImage(user.user_headpic ?? "")
        cell.ys_titleLabel.text = user.user_name ?? ""
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
