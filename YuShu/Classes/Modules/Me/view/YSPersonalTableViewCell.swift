//
//  YSPersonalTableViewCell.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/18.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSPersonalTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var midLabel: UILabel!
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.corner()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
