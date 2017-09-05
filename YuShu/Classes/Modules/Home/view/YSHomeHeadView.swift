//
//  YSHomeHeadView.swift
//  YuShu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import pop
let num: CGFloat = 4
let itemW = (KScreenWidth - (num + 1) * 10)/num
class YSHomeHeadView: UIView {
    let eightTitles = ["","","","","","","",""]
    
    @IBOutlet weak var ys_adsuperView: UIView!
    
    @IBOutlet weak var ys_showView: UIView!
    @IBOutlet weak var ys_collectionView: UICollectionView!
    
    @IBOutlet weak var ys_flowLayout: UICollectionViewFlowLayout!
    
    
    @IBAction func ys_showClicked(_ sender: UIButton) {
        
        
    }
    //MARK: public
    static func `default`()-> YSHomeHeadView?{
        
        let nibView = Bundle.main.loadNibNamed("YSHomeHeadView", owner: nil, options: nil)
        if let vi = nibView?.first as? YSHomeHeadView{
            return vi
        }
        return nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupAnimate()
    }
    
    func setupUI() {
        ys_flowLayout.itemSize = CGSize(width: itemW, height: itemW)
        ys_flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        ys_collectionView.register(str: "YSHomeCollectionViewCell")
    }
    
    func setupAnimate() {
        if let anim = POPSpringAnimation(propertyNamed: kPOPViewBoundsRotation) {
            anim.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 400, height: 400))
            ys_showView.layer.pop_add(anim, forKey: "")
        }
    }
}

extension YSHomeHeadView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eightTitles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSHomeCollectionViewCell", for: indexPath) as! YSHomeCollectionViewCell
        return cell
    }
}
