//
//  YSVoteDetailHeader.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/12.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSVoteDetailHeader: UIView {

    var vote: VoteDetail? {
        didSet{
            setupInit()
        }
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!

    @IBOutlet weak var statusImageView: UIImageView!
    
    //MARK: public
    static func `default`()-> YSVoteDetailHeader?{
        
        let nibView = Bundle.main.loadNibNamed("YSVoteDetailHeader", owner: nil, options: nil)
        if let vi = nibView?.first as? YSVoteDetailHeader{
            return vi
        }
        return nil
    }
    
    func setupInit(){
        guard let item = vote else {return}
        titleLabel.text = item.vote_title
        contentLabel.text = item.vote_desc
        statusImageView.image = UIImage(named: (item.vote_status ?? "").statusImage())
        
    }
}
