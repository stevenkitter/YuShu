//
//  MeInfoTableViewCell.swift
//  InternManager
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class MeInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var wxContentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
