//
//  YSVoteMemberLayout.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/11.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
//头像的布局
class YSVoteMemberLayout: UICollectionViewFlowLayout {
    fileprivate lazy var attrsArray : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate var maxY : CGFloat = 0
    fileprivate let cellW: CGFloat = 30
    fileprivate let space: CGFloat = 8
    override func prepare() {
        super.prepare()
        attrsArray.removeAll()
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        for i in 0..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attrs.frame = CGRect(x: CGFloat(i) * (cellW - space), y: 0, width: cellW, height: cellW)
            attrsArray.append(attrs)
        }
    }
}

extension YSVoteMemberLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    override var collectionViewContentSize: CGSize {
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        let width = userHeadWidth(space, CGFloat(itemCount), cellW)
        return CGSize(width: width, height: cellW)
    }
}
