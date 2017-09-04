//
//  UITextField+LeftView.swift
//  InternManager
//
//  Created by apple on 2017/8/11.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import MJRefresh
extension UITextField {
    func leftViewWithImageName(imageName: String) {
        let iconFrame = CGRect(x: 15, y: 15, width: 20, height: 20)
        let iconImage = UIImageView(image: UIImage(named: imageName))
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        iconImage.frame = iconFrame;
        containerView.addSubview(iconImage)
        self.leftView = containerView
        self.leftViewMode = .always
    }
    func textRectMaxH()-> CGRect {
        
        let nsStr = NSString(string: self.text ?? "")
        let rect = nsStr.boundingRect(with: CGSize(width: self.mj_w, height: 8888), options: [.usesLineFragmentOrigin,.truncatesLastVisibleLine,.usesFontLeading], attributes: [NSFontAttributeName: self.font ?? UIFont.systemFont(ofSize: 14)], context: nil)
        return rect
    }
}
