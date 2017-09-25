//
//  YSFitmentTableViewCell.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/25.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSFitmentTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var ys_titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
