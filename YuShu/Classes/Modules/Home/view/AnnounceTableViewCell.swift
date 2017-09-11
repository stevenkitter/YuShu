//
//  AnnounceTableViewCell.swift
//  YuShu
//
//  Created by apple on 2017/9/11.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class AnnounceTableViewCell: UITableViewCell {

    @IBOutlet weak var ys_imageView: UIImageView!
    
    @IBOutlet weak var ys_titleLabel: UILabel!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var starBtn: UIButton!
    
    var annouce: Announce? {
        didSet{
            setupInit()
        }
    }
    
    func setupInit() {
        guard let item = annouce else {return}
        ys_imageView.kfImage(item.adminnotice_image_path ?? "")
        ys_titleLabel.text = item.adminnotice_title
        timeLabel.text = (item.adminnotice_addtime ?? "").timeStr()
        commentBtn.setTitle(item.adminnotice_comment_count, for: .normal)
        starBtn.setTitle(item.adminnotice_praise_count, for: .normal)
        
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
