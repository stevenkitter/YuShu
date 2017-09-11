//
//  YSVoteMemberLayout.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/11.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSVoteMemberLayout: UICollectionViewFlowLayout {
    fileprivate lazy var attrsArray : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate var maxY : CGFloat = 0
    fileprivate let cellW: CGFloat = 30
    
    override func prepare() {
        super.prepare()
        attrsArray.removeAll()
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        for i in 0..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attrs.frame = CGRect(x: CGFloat(i * 20), y: 0, width: cellW, height: cellW)
            attrsArray.append(attrs)
        }
    }
}

extension YSVoteMemberLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: cellW)
    }
}
