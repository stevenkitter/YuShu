//
//  YSVoteTableViewCell.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/11.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSVoteTableViewCell: UITableViewCell {
    var vote: Vote?{
        didSet{
            setupInit()
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var ys_titleLabel: UILabel!
    
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    
    func setupInit() {
        
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
