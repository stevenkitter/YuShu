//
//  YSHomeTableViewCell.swift
//  YuShu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
let homeCellNum: CGFloat = 2
let homeCellSpace: CGFloat = 10
let homeCellW = (KScreenWidth - (homeCellNum + 1) * homeCellSpace) / homeCellNum
let homeCellH = homeCellW + 30
class YSHomeTableViewCell: UITableViewCell {
    var models: [Slide] = [] {
        didSet{
            reSetupUI()
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI(){
        flowLayout.itemSize = CGSize(width: homeCellW, height: homeCellH)
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        collectionView.register(str: "YSHomeCollectionViewCell")
    }
    
    func reSetupUI() {
        //行数
        let row = Int((models.count + 1) / Int(homeCellNum))
        let colH = CGFloat(row) * homeCellH + CGFloat(row + 1) * homeCellSpace
        collectionViewHeight.constant = colH
        self.collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension YSHomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count > 8 ? 8 : models.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSHomeCollectionViewCell", for: indexPath) as! YSHomeCollectionViewCell
        cell.ys_imageView.kfImage(model.slide_image_path ?? "")
        cell.ys_titleLabel.text = model.slide_title
        return cell
    }
}
