//
//  YSEditMeImageTableViewCell.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSEditMeImageTableViewCell: UITableViewCell {

    @IBOutlet weak var ys_titleLabel: UILabel!
    @IBOutlet weak var ys_imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ys_imageView.cornerRadius(width: 54)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
