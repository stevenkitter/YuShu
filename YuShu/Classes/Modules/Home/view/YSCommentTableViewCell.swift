//
//  YSCommentTableViewCell.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/12.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSCommentTableViewCell: UITableViewCell {
    var comment: Comment? {
        didSet{
            setupInit()
        }
    }
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    func setupInit(){
        guard let item = comment else {return}
        iconImageView.kfImage(item.user_headpic ?? "")
        nameLabel.text = item.user_name
        
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
