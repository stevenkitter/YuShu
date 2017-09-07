//
//  YSMeTableViewCell.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/7.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSMeTableViewCell: UITableViewCell {

    @IBOutlet weak var ys_detailLabel: UILabel!
    @IBOutlet weak var ys_titleLabel: UILabel!
    @IBOutlet weak var ys_imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
