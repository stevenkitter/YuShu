//
//  WXCancelCollectionViewCell.swift
//  InternManager
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class WXCancelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var deleteBtn: UIButton!
    
    var closure: (()->Void)?
    
    @IBAction func deleteAction(_ sender: UIButton) {
        closure?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
