//
//  InlineFunc.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/7.
//  Copyright © 2017年 coderX. All rights reserved.
//

import Foundation
import UIKit

/// 一个屏幕宽度放几个cell的宽度
let cellWidth = { (space: CGFloat, num: CGFloat)->CGFloat in
                    return (KScreenWidth - (num + 1) * space) / num
                }

// 头像布局的整个宽度
let userHeadWidth = { (space: CGFloat, num: CGFloat, cellW: CGFloat)->CGFloat in
    
    let wi = (num - 1) * (cellW - space) + cellW
    return wi
}


