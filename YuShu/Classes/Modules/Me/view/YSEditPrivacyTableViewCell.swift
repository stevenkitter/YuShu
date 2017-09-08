//
//  YSEditPrivacyTableViewCell.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/8.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSEditPrivacyTableViewCell: UITableViewCell {

    @IBOutlet weak var ys_titleLabel: UILabel!
    
    @IBOutlet weak var `switch`: UISwitch!
    var sure: ((_ on: Bool)-> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func change(_ sender: UISwitch) {
        sure?(sender.isOn)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
