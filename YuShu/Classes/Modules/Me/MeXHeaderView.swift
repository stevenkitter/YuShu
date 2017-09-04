//
//  MeXHeaderView.swift
//  InternManager
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class MeXHeaderView: UIView {
    
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var collectLabel: UILabel!
    
    @IBOutlet weak var submitLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var clickedClosure: ((_ tag: Int)-> Void)?
    
    var userInfo: UserInfo? {
        didSet{
            setupData()
        }
    }
    
    static func instance()-> MeXHeaderView?{
        let nibView = Bundle.main.loadNibNamed("MeXHeaderView", owner: nil, options: nil)
        if let vi = nibView?.first as? MeXHeaderView{
            return vi
        }
        return nil

    }
    
    
    /// 头部点击
    ///
    /// - Parameter sender: 按钮覆盖头像 名字
    @IBAction func headClickedAction(_ sender: UIButton) {
        clickedClosure?(3)
    }
    
    /// 3个点击事件
    ///
    /// - Parameter sender: 0 1 2 收藏 发表 积分
    @IBAction func clickedAction(_ sender: UITapGestureRecognizer) {
        guard let clickedViewTag = sender.view?.tag else{
            return
        }
        
        clickedClosure?(clickedViewTag)
        
    }
    
    func setupData() {
        guard let item = self.userInfo else {
            iconImageView.kf.setImage(with: URL(string: ""), placeholder: KPlaceholderImage)
            usernameLabel.text = "登录/注册"
            levelLabel.text = ""
            collectLabel.text = "收藏: 0"
            submitLabel.text = "发表: 0"
            scoreLabel.text = "积分: 0"
            return
        }
        
        iconImageView.kf.setImage(with: URL(string: item.user_avatar ?? ""), placeholder: KPlaceholderImage)
        usernameLabel.text = (item.user_nickname ?? "").exactStr(one: item.user_name ?? "", two: item.user_phone ?? "")
        levelLabel.text = "新手上路"
        collectLabel.text = "收藏: \(item.collect ?? "0")"
        submitLabel.text = "发表: \(item.publish ?? "0")"
        scoreLabel.text = "积分: \(item.points ?? "0")"
    }
    

}
