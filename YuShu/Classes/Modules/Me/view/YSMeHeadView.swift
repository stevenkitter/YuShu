//
//  YSMeHeadView.swift
//  YuShu
//
//  Created by hsgene_xu on 2017/9/6.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
let ysMeHeadViewH = KScreenWidth * ratio + 120


class YSMeHeadView: UIView {
    
    let cells = [YSMeHeadViewCellM(image: "我发布的", title: "我发布的", num: "2"),YSMeHeadViewCellM(image: "我收藏的", title: "我收藏的", num: "2"), YSMeHeadViewCellM(image: "我评论的", title: "我评论的", num: "2"),
                 YSMeHeadViewCellM(image: "我点赞的", title: "我点赞的", num: "2")]
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var userDetailLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    @IBOutlet weak var centerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    //MARK: public
    static func `default`()-> YSMeHeadView?{
        
        let nibView = Bundle.main.loadNibNamed("YSMeHeadView", owner: nil, options: nil)
        if let vi = nibView?.first as? YSMeHeadView{
            return vi
        }
        return nil
    }
    
    func setupUI(){
        flowLayout.itemSize = CGSize(width: itemW, height: 120 - 17.5)
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        flowLayout.scrollDirection = .horizontal
        collectionView.register(str: "YSMeHeadCollectionViewCell")
        centerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        centerView.layer.shadowColor = UIColor.lightGray.cgColor
        
        iconImageView.cornerRadiusBorder(width: 80, border: 4)
    }
    
    func setupInfo() {
        guard let user = UserManager.shareUserManager.curUserInfo else {return}
        iconImageView.kfImage(user.user_headpic ?? "")
        nameLabel.text = user.user_name ?? ""
        floorLabel.text = (user.user_floor ?? "") + "栋" + (user.user_room ?? "")
        userDetailLabel.text = "您已经使用御墅社区2个多月了，感谢您在这期间的支持"
        
    }
}

extension YSMeHeadView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = cells[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSMeHeadCollectionViewCell", for: indexPath) as! YSMeHeadCollectionViewCell
        cell.iconImageView.image = UIImage(named: model.image)
        cell.titleLabel.text = model.title
        cell.numLabel.text = model.num
        return cell
    }
}


//编辑cell的模型
struct YSMeHeadViewCellM {
    var image = ""
    var title = ""
    var num = ""
}
