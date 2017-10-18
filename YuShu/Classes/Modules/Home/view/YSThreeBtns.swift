//
//  YSThreeBtns.swift
//  YuShu
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSThreeBtns: UIView {

    @IBAction func clicked(_ sender: UIButton) {
        closure?(sender)
    }
    var closure: ((_ btn: UIButton)->Void)?
    //MARK: public
    static func `default`()-> YSThreeBtns?{
        
        let nibView = Bundle.main.loadNibNamed("YSThreeBtns", owner: nil, options: nil)
        if let vi = nibView?.first as? YSThreeBtns{
            return vi
        }
        return nil
    }

}
