//
//  YSMoreImageCollectionReusableView.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/7.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSMoreImageCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var backImageView: UIImageView!
    
    
    var closure: (()-> Void)?
    
    @IBAction func clicked(_ sender: UIButton) {
        closure?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
