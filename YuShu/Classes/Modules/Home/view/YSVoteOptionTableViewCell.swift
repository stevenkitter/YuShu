//
//  YSVoteOptionTableViewCell.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/12.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSVoteOptionTableViewCell: UITableViewCell {
    var canEdit = false
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var ys_detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard canEdit else{
            return
        }
        selectButton.isSelected = selected
    }
    
}
