//
//  CommentListTableViewCell.swift
//  InternManager
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import Kingfisher
class CommentListTableViewCell: UITableViewCell {
    var comment: Comment? {
        didSet{
            setupUIData()
        }
    }
    
    
    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var commentsTabelView: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    /// -1: 回复按钮点击 0-max: 子cell点击
    var closure: ((_ tag: Int)->Void)?
    
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        closure?(-1)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commentsTabelView.register(UINib(nibName: "CommentResTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentResTableViewCell")
        commentsTabelView.estimatedRowHeight = 80
    }
    
    func setupUIData() {
        guard let item = self.comment else {
            return
        }
        iconImageView.kf.setImage(with: URL(string: item.user_avatar), placeholder: KPlaceholderImage)
        nameLabel.text = item.user_nickName.exactStr(one: item.user_name, two: item.user_phone)
        contentLabel.text = item.comment_content
        timeLabel.text = item.comment_date
        tableViewHeight.constant = getTableViewHeight()
        commentsTabelView.reloadData()
    }
    
    func getTableViewHeight()-> CGFloat {
        guard let item = self.comment else {
            return 0
        }
        if item.replay.count == 0 {
            return 0
        }
        var totalH: CGFloat = 0
        let margins: CGFloat = 10
        for subComment in item.replay {
            let username = subComment.user_nickName.exactStr(one: subComment.user_name, two: subComment.user_phone)
            let str = username + ": " + subComment.comment_content
            let strH = str.strRectMaxH(self.commentsTabelView.frame.width, font: UIFont.systemFont(ofSize: 13))
            totalH += (margins + strH)
        }
        return totalH
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension CommentListTableViewCell: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comment == nil {
            return 0
        }
        return comment?.replay.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subComment = comment!.replay[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentResTableViewCell", for: indexPath) as! CommentResTableViewCell
        let username = subComment.user_nickName.exactStr(one: subComment.user_name, two: subComment.user_phone)
        let str = username + ": " + subComment.comment_content
        cell.contentLabel.text = str
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.closure?(indexPath.row)
    }
}
