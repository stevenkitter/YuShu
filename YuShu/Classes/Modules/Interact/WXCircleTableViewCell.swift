//
//  WXCircleTableViewCell.swift
//  InternManager
//
//  Created by apple on 2017/8/30.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import Lightbox
let num: CGFloat = 3
let space: CGFloat = 10
class WXCircleTableViewCell: UITableViewCell {
    var circle: Circle? {
        didSet {
            setupData()
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    
    /// -1: 回复按钮点击 0-max: 子cell点击
    var closure: ((_ tag: Int)->Void)?
    
    @IBAction func clickedAction(_ sender: UIButton) {
        closure?(-1)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.estimatedRowHeight = 150
        let cellWidth = cellW()
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        
        collectionView.register(UINib(nibName: "WXImageViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WXImageViewCollectionViewCell")
        tableView.register(UINib(nibName: "CommentResTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentResTableViewCell")
    }
    
    
    func setupData() {
        guard let item = circle else {
            return
        }
        iconImageView.kf.setImage(with: URL(string: item.user_avatar ?? ""), placeholder: KPlaceholderImage)
        let username = (item.user_nickname ?? "").exactStr(one: item.user_name ?? "", two: item.user_phone ?? "")
        nameLabel.text = username
        contentLabel.text = item.friend_content
        timeLabel.text = item.friend_addtime
        tableViewHeight.constant = getTableViewHeight()
        tableView.reloadData()
        
        collectionViewHeight.constant = getCollectionViewH()
        collectionView.reloadData()
    }
    
    func getTableViewHeight()-> CGFloat {
        guard let item = self.circle else {
            return 0
        }
        if item.comment.count == 0 {
            return 0
        }
        var totalH: CGFloat = 0
        let margins: CGFloat = 10
        for subComment in item.comment {
            let username = (subComment.user_nickname ?? "").exactStr(one: "", two: subComment.user_phone ?? "")
            let str = username + ": " + (subComment.comment_content ?? "")
            let strH = str.strRectMaxH(self.tableView.frame.width, font: UIFont.systemFont(ofSize: 13))
            totalH += (margins + strH)
        }
        return totalH
    }
    
    func getCollectionViewH()-> CGFloat {
        guard let item = self.circle else {
            return 0
        }
        if item.img.count == 0 {
            return 0
        }
        let cellWidth = cellW()
        let row = ((item.img.count - 1) / Int(num)) + 1
        let rowF = CGFloat(row)
        let colH = cellWidth * rowF + (rowF - 1) * space
        return colH
    }
    
    func cellW()-> CGFloat {
        
        
        let cellW = (KScreenWidth - 20 - (num - 1) * space) / num
        return cellW
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension WXCircleTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if circle == nil {
            return 0
        }
        return circle?.img.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let img = circle?.img[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WXImageViewCollectionViewCell", for: indexPath) as! WXImageViewCollectionViewCell
        cell.imageView.kf.setImage(with: URL(string: img?.file_path_small ?? ""), placeholder: KPlaceholderImage)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let images = circle?.img else{
            return
        }
        var paths: [LightboxImage] = []
        for item in images {
            if let path = item.file_path {
                let box = LightboxImage(imageURL: URL(string: path)!)
                paths.append(box)
            }
            
        }
        let lightbox = LightboxController(images: paths, startIndex: indexPath.item)
        guard let vc = self.superVc() else {
            return
        }
        vc.present(lightbox, animated: true, completion: nil)
        
    }
}

extension WXCircleTableViewCell: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if circle == nil {
            return 0
        }
        return circle?.comment.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = circle?.comment[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentResTableViewCell", for: indexPath) as! CommentResTableViewCell
        let username = (comment?.user_nickname ?? "").exactStr(one: "", two: comment?.user_phone ?? "")
        cell.contentLabel.text = "\(username): \(comment?.comment_content ?? "")"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        closure?(indexPath.row)
    }
}
