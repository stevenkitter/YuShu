//
//  HomeTableViewCell.swift
//  InternManager
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import Kingfisher
class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    var model:Article? {
        didSet {
            setupUIData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUIData() {
        guard let item = self.model else {
            return
        }
        
        iconImageView.kf.setImage(with: URL(string: item.file_path ?? ""), placeholder: KPlaceholderImage)
        titleLabel.text = item.article_title ?? ""
        timeLabel.text = item.article_date
        contentLabel.text = item.article_content
        likesLabel.text = "阅读 \(item.article_readcount ?? "0") · 评论 \(item.commentcount ?? "0") · 收藏 \(item.likecount ?? "0")"
    }
    
}
