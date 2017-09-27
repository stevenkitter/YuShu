//
//  YSPostSuggestDetailHeadView.swift
//  YuShu
//
//  Created by apple on 2017/9/17.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import Lightbox

class YSPostSuggestDetailHeadView: UIView {
    
    var transfer: PostSuggest? {
        didSet{
            setupInit()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var userIconImageView: UIImageView!
   
    @IBOutlet weak var usernameLabel: UILabel!

   
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    //MARK: public
    static func `default`()-> YSPostSuggestDetailHeadView?{
        
        let nibView = Bundle.main.loadNibNamed("YSPostSuggestDetailHeadView", owner: nil, options: nil)
        if let vi = nibView?.first as? YSPostSuggestDetailHeadView{
            return vi
        }
        return nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    fileprivate func setupUI() {
        layout.itemSize = CGSize(width: KScreenWidth - 20, height: 250)
        layout.scrollDirection = .vertical
        userIconImageView.cornerRadius(width: 30)
        imagesCollectionView.register(str: "YSUserHeadCollectionViewCell")
    }
    
    fileprivate func setupInit() {
        guard let item = transfer else {return}
        titleLabel.text = item.post_title
        userIconImageView.kfImage(item.user_headpic ?? "")
        usernameLabel.text = item.user_name
        contentLabel.text = item.post_desc
        
        let colH = item.images.count == 0 ? 0 : CGFloat(item.images.count) * YSTransferDetailHeadViewCellH + CGFloat(item.images.count - 1) * 10
        
        collectionViewHeight.constant = colH
        imagesCollectionView.reloadData()
    }
    
    
    
    
    
}
extension YSPostSuggestDetailHeadView: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transfer?.images.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = transfer?.images[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSUserHeadCollectionViewCell", for: indexPath) as! YSUserHeadCollectionViewCell
        cell.iconImageView.kfImageNormal(image?.uploadimage_path_small ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let imags = transfer?.images else {return}
        var imageUrls: [String] = []
        for item in imags{
            imageUrls.append(item.uploadimage_path ?? "")
        }
        showImages(index: indexPath.item,imageUrls: imageUrls)
    }
}



extension UIView{
  
    
    static func transferDetailHeadViewH(transfer: PostSuggest)-> CGFloat {
        var headH: CGFloat = 80 + 10
        headH += (40 + 20)
        
        let contentH = (transfer.post_desc ?? "").strRectMaxH(KScreenWidth - 20, font: UIFont.systemFont(ofSize: 14))
        headH += contentH
        
        let colH = transfer.images.count == 0 ? 0 : CGFloat(transfer.images.count) * YSTransferDetailHeadViewCellH + CGFloat(transfer.images.count - 1) * 10
        headH += colH
        
        return headH
    }
}
