//
//  AnnounceTableViewCell.swift
//  YuShu
//
//  Created by apple on 2017/9/11.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class AnnounceTableViewCell: UITableViewCell {

 
    
    @IBOutlet weak var ys_titleLabel: UILabel!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    
    var annouce: Announce? {
        didSet{
            setupInit()
        }
    }
    
    func setupInit() {
        guard let item = annouce else {return}
      
        ys_titleLabel.text = item.adminnotice_title
        timeLabel.text = (item.adminnotice_addtime ?? "").timeStr()
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
