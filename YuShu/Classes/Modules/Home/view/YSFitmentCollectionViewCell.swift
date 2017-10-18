//
//  YSFitmentCollectionViewCell.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/25.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSFitmentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var favourBtn: UIButton!
    
    @IBOutlet weak var addTimeLabel: UILabel!
    
    var fitment: Fitment?{
        didSet{
            setupInit()
        }
    }
    
    func setupInit(){
        iconImageView.kfImageNormal(fitment?.guide_image_path ?? "")
        contentLabel.text = fitment?.guide_title ?? ""
        addTimeLabel.text = (fitment?.guide_addtime ?? "").timeAgo()
        favourBtn.setTitle(fitment?.guide_praise_count ?? "", for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
