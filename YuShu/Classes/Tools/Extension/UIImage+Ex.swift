//
//  UIImage+Ex.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/27.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    func scaleToSize(size: CGSize) -> UIImage?{
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaled = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaled
    }
}
