//
//  YSVoteTableViewCell.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/11.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit

class YSVoteTableViewCell: UITableViewCell {
    var vote: Vote?{
        didSet{
            setupInit()
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var ys_titleLabel: UILabel!
    
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var deadTimeLabel: UILabel!
    
    func setupInit() {
        guard let item = vote else {return}
        iconImageView.kfImageVote(item.vote_image_path ?? "")
        ys_titleLabel.text = item.vote_title
        statusImageView.image = UIImage(named: (item.vote_status?.statusImage() ?? ""))
        let cellNumber = min(5, item.praise_user_list.count)
        let width = userHeadWidth(8, CGFloat(cellNumber), 30)
        collectionViewWidth.constant = width
//        numberLabel.text = "总数:\(item.praise_user_list.count)"
        numberLabel.text = ""
        let time = item.vote_endtime?.timeMintStr()
        deadTimeLabel.text = "截止：\(time ?? "")"
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(str: "YSUserHeadCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension YSVoteTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vote?.praise_user_list.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let user = vote?.praise_user_list[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSUserHeadCollectionViewCell", for: indexPath) as! YSUserHeadCollectionViewCell
        cell.iconImageView.kfImage(user?.user_headpic ?? "")
        return cell
    }
}
