//
//  CommentToolView.swift
//  InternManager
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
class CommentToolView: UIView {
    let dispose = DisposeBag()
    @IBOutlet weak var likeBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var shareBtnWidth: NSLayoutConstraint!
    
    @IBOutlet weak var textFieldHeight: NSLayoutConstraint!
    
    @IBOutlet weak var textField: UITextView!

    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var actionBlock: ((_ sender: UIButton)-> Void)?
    var article_id = ""
    //:MARK public
    static func `default`()-> CommentToolView?{
        
        let nibView = Bundle.main.loadNibNamed("CommentToolView", owner: nil, options: nil)
        if let vi = nibView?.first as? CommentToolView{
            return vi
        }
        return nil
    }
    
  
    
    /// 按钮点击
    ///
    /// - Parameter sender: tag 0 1 2 收藏 分享 发送
    @IBAction func buttonClickedAction(_ sender: UIButton) {
        
        
        actionBlock?(sender)
    }
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let _ = textField.rx.text.orEmpty.subscribe(onNext: { [unowned self] (text) in
            let h = text.strRectMaxH(self.textField.frame.width, font: self.textField.font)
            let cons = min(max(35, h + 10), 120)
            self.textFieldHeight.constant = cons
            self.sendButton.isEnabled = text.characters.count > 0
        }).addDisposableTo(dispose)
        NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillChangeFrame).subscribe(onNext: { [unowned self] (noti) in
            self.keyboardChange(noti: noti)
        }).addDisposableTo(dispose)
        
    }
    
    func keyboardChange(noti: Notification) -> Void {
        if let frameValue = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let frame = frameValue.cgRectValue
            let selfY = KScreenHeight - frame.origin.y
            self.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self.superview!).offset(-selfY)
            })
            if let dura = noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber{
                let duration = dura.doubleValue
                UIView.animate(withDuration: duration, animations: { 
                    self.superview?.layoutIfNeeded()
                })
            }
            
        }
        
    }
    
    /// 隐藏除了发送按钮
    func onlySend() {
        likeBtnWidth.constant = 0
        shareBtnWidth.constant = 0
    }
    
    func loadUserInfo() {
        guard let userid = UserManager.shareUserManager.curUserInfo?.id else {
            return
        }
        NetworkManager.providerHomeApi.request(.isCollect(article_id: article_id, user_id: userid)).mapJSON().subscribe(onNext: { [unowned self] (res) in
            let respon = res as! Dictionary<String, Any>
            let isCollected = (respon["data"] as! Dictionary<String, Any>)["data"] as! String
            self.likeButton.isSelected = isCollected == "1"
        }).addDisposableTo(dispose)
    }
}

