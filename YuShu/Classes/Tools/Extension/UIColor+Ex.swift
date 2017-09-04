//
//  UIColor+Ex.swift
//  InternManager
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    func createImage()-> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
