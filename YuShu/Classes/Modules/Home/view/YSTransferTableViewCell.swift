//
//  YSTransferTableViewCell.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/15.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import Lightbox
class YSTransferTableViewCell: UITableViewCell {

    var transfer: Transfer? {
        didSet{
            setupInit()
        }
    }
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var typeBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var ys_titleLabel: UILabel!
    
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var favourBtn: UIButton!
    
    
    func setupInit() {
        guard let item = transfer else {return}
        iconImageView.kfImage(item.user_headpic ?? "")
        usernameLabel.text = item.user_name ?? ""
        typeBtn.setTitle(item.transfer_type == "2" ? " 置换" : " 馈赠", for: .normal)
        ys_titleLabel.text = item.transfer_title ?? ""
        commentBtn.setTitle(item.transfer_comment_count ?? "", for: .normal)
        favourBtn.setTitle(item.transfer_praise_count ?? "", for: .normal)
        let num = transfer?.images.count ?? 0
        collectionViewHeight.constant = num == 0 ? 0 : 110
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(str: "YSUserHeadCollectionViewCell")
        iconImageView.cornerRadius(width: 30)
        typeBtn.corner()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension YSTransferTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transfer?.images.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let im = transfer?.images[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSUserHeadCollectionViewCell", for: indexPath) as! YSUserHeadCollectionViewCell
        cell.iconImageView.kfImageNormal(im?.uploadimage_path_small ?? "")
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




