//
//  YSAddImageCollectionViewCell.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/15.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit


class YSAddImageCollectionViewCell: UICollectionViewCell {
    var closure: (()-> Void)?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func deleteImage(_ sender: UIButton) {
        closure?()
    }
   
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
