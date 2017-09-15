//
//  YSRoomUserCollectionViewCell.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/15.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSRoomUserCollectionViewCell: UICollectionViewCell {
    var user: PraiseUser? {
        didSet{
            setupInit()
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    func setupInit() {
        guard let item = user else {return}
        usernameLabel.text = item.user_name ?? ""
        iconImageView.kfImage(item.user_headpic ?? "")
        iconImageView.cornerRadiusBorder(width: 30, border: 2,selected: item.user_status != "0")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.cornerRadius(width: 30)
    }

}
