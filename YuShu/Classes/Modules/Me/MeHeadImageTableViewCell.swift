//
//  MeHeadImageTableViewCell.swift
//  InternManager
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import Lightbox
class MeHeadImageTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var wxImageView: UIImageView!
    
   
    
    
    @IBAction func taped(_ sender: UIButton) {
        guard let wxImage = wxImageView.image else {
            return
        }
        
        
        let lightboxImages = [wxImage].map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        
        
        guard let vc = self.superVc() else {
            return
        }
        vc.present(lightbox, animated: true, completion: nil)

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
