//
//  YSHomeTableViewCell.swift
//  YuShu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import Lightbox
let homeCellNum: CGFloat = 3
let homeCellSpace: CGFloat = 10
let homeCellW = (KScreenWidth - (homeCellNum + 1) * homeCellSpace) / homeCellNum
let homeCellH = homeCellW + 70
class YSHomeTableViewCell: UITableViewCell {
    var models: [Any] = [] {
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
        let row = Int((models.count - 1) / Int(homeCellNum)) + 1
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
        return models.count > 6 ? 6 : models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSHomeCollectionViewCell", for: indexPath) as! YSHomeCollectionViewCell
        if let imageM = model as? ImageFile  {
            cell.ys_imageView.kfImage(imageM.image_file_path ?? "")
            cell.ys_titleLabel.text = imageM.image_title

        }
        if let imageM = model as? VideoFile  {
            cell.ys_imageView.kfImage(imageM.video_logo_path ?? "")
            cell.ys_titleLabel.text = imageM.video_title
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = models[indexPath.item]
        guard let imageM = model as? VideoFile  else{
            var paths: [LightboxImage] = []
            for model in models {
                if let imageM = model as? ImageFile  {
                    
                    if let url = imageM.image_file_path {
                        let box = LightboxImage(imageURL: URL(string: url)!)
                        paths.append(box)
                    }
                    
                }
            }
            let lightBox = LightboxController(images: paths, startIndex: indexPath.item)
            guard let vc = self.superVc() else {return}
            vc.present(lightBox, animated: true, completion: nil)
            return
        }
        
        
    }
}
