//
//  WXMessageListTableViewCell.swift
//  InternManager
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class WXMessageListTableViewCell: UITableViewCell {
    var message: WXMessage?
    {
        didSet{
            setupInit()
        }
    }
    
    @IBOutlet weak var wxNameLabel: UILabel!
    
    @IBOutlet weak var wxContentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var wxImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupInit() {
        guard let item = message else {return}
        wxNameLabel.text = (item.user_nickname ?? "").exactStr(one: item.user_name ?? "", two: item.user_phone ?? "")
        wxContentLabel.text = item.comment_content
        timeLabel.text = item.comment_date
        wxImageView.kfImage(item.user_avatar ?? "")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
