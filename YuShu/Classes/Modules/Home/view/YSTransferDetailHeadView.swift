//
//  YSTransferDetailHeadView.swift
//  YuShu
//
//  Created by apple on 2017/9/17.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import Lightbox
let YSTransferDetailHeadViewCellH: CGFloat = 250
class YSTransferDetailHeadView: UIView {
    var transfer: Transfer? {
        didSet{
            setupInit()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var userIconImageView: UIImageView!
   
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var transferTypeBtn: UIButton!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    //MARK: public
    static func `default`()-> YSTransferDetailHeadView?{
        
        let nibView = Bundle.main.loadNibNamed("YSTransferDetailHeadView", owner: nil, options: nil)
        if let vi = nibView?.first as? YSTransferDetailHeadView{
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
        titleLabel.text = item.transfer_title
        userIconImageView.kfImage(item.user_headpic ?? "")
        usernameLabel.text = item.user_name
        transferTypeBtn.setTitle(item.transfer_type == "2" ? " 置换" : " 馈赠", for: .normal)
        contentLabel.text = item.transfer_desc
        
        let colH = item.images.count == 0 ? 0 : CGFloat(item.images.count) * YSTransferDetailHeadViewCellH + CGFloat(item.images.count - 1) * 10
        
        collectionViewHeight.constant = colH
        imagesCollectionView.reloadData()
    }
    
    
    
    
    
}
extension YSTransferDetailHeadView: UICollectionViewDelegate,UICollectionViewDataSource {
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
        showImages(index: indexPath.item)
    }
}

extension YSTransferDetailHeadView {
    func showImages(index: Int) {
        guard let ims = transfer?.images else {return}
        var paths: [LightboxImage] = []
        for item in ims {
            if let path = item.uploadimage_path {
                let box = LightboxImage(imageURL: URL(string: path)!)
                paths.append(box)
            }
        }
        
        let boxV = LightboxController(images: paths, startIndex: index)
        guard let superVc = self.superVc() else {
            return
        }
        superVc.present(boxV, animated: true, completion: nil)
    }
}

extension UIView{
    static func transferDetailHeadViewH(transfer: Transfer)-> CGFloat {
        var headH: CGFloat = 120 + 10
        headH += 40
        let contentH = (transfer.transfer_desc ?? "").strRectMaxH(KScreenWidth - 20, font: UIFont.systemFont(ofSize: 14))
        headH += contentH
        
        let colH = transfer.images.count == 0 ? 0 : CGFloat(transfer.images.count) * YSTransferDetailHeadViewCellH + CGFloat(transfer.images.count - 1) * 10
        headH += colH
        
        return headH
    }
}
