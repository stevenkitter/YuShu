//
//  YSHomeHeadView.swift
//  YuShu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import LLCycleScrollView
let num: CGFloat = 4
let itemW = (KScreenWidth - (num + 1) * 10)/num
let labelSpace: CGFloat = 60

class YSHomeHeadView: UIView {
    
    var timer: DispatchSourceTimer!
    let eightTitles = ["群主公告","闲置转让","物业人事","民意投票","御墅论坛","装修指南","小区公约","周边便民"]
    var noticeStr = "" {
        didSet{
            self.setupAnimate()
        }
    }
    var ads: [Slide]? {
        didSet{
            adsSetup()
        }
    }
    
    let appendLabel = UILabel()
    
    var adView: LLCycleScrollView!
    
    @IBOutlet weak var broadView: UIView!
    @IBOutlet weak var scroLabel: UILabel!
    
    @IBOutlet weak var ys_adsuperView: UIView!
    
    @IBOutlet weak var ys_showView: UIView!
    
    @IBOutlet weak var ys_collectionView: UICollectionView!
    
    @IBOutlet weak var ys_collectionViewHeight: NSLayoutConstraint!

    @IBOutlet weak var ys_flowLayout: UICollectionViewFlowLayout!
    
    
    @IBAction func ys_showClicked(_ sender: UIButton) {
        
        
    }
    //MARK: public
    static func `default`()-> YSHomeHeadView?{
        
        let nibView = Bundle.main.loadNibNamed("YSHomeHeadView", owner: nil, options: nil)
        if let vi = nibView?.first as? YSHomeHeadView{
            return vi
        }
        return nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
       
    }
    
   
    func setupUI() {
        ys_flowLayout.itemSize = CGSize(width: itemW, height: itemW)
        ys_flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        ys_collectionView.register(str: "YSHomeEightCollectionViewCell")
        
        ys_collectionViewHeight.constant = itemW * 2 + 30
        
        self.ys_showView.addSubview(appendLabel)
        appendLabel.font = scroLabel.font
        appendLabel.textColor = scroLabel.textColor
        
        adView = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenWidth * ratio), didSelectItemAtIndex: { [unowned self] (index) in
            guard let superV = self.superVc() else {return}
            guard let thisAds = self.ads else {return}
            let ad = thisAds[index]
            let vc = YSWebViewController()
            vc.url = WebUrl + (ad.slide_id ?? "")
            vc.hidesBottomBarWhenPushed = true
            superV.navigationController?.pushViewController(vc, animated: true)
        })
        adView.autoScroll = true
        adView.autoScrollTimeInterval = 4.0
        adView.customPageControlStyle = .snake
        adView.titleBackgroundColor = UIColor.clear
        
        ys_adsuperView.addSubview(adView)
        
        broadView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        broadView.layer.borderWidth = 0.8
    }
    
    func setLabelFrame() {
        let ys_maxSuperW = self.ys_showView.frame.width
        let ys_maxX = noticeStr.strRectMaxW(self.scroLabel.frame.height, font: self.scroLabel.font)
        
        
        if ys_maxSuperW - ys_maxX > labelSpace {
            self.appendLabel.frame = CGRect(x: ys_maxSuperW, y: self.scroLabel.frame.origin.y, width: self.scroLabel.frame.width, height: self.scroLabel.frame.height)
        }else{
            appendLabel.frame = CGRect(x: ys_maxX + labelSpace, y: self.scroLabel.frame.origin.y, width: self.scroLabel.frame.width, height: self.scroLabel.frame.height)
        }
    }
    
    func resetFrame() {
        let ys_maxSuperW = self.ys_showView.frame.width
        
        let scroX = self.scroLabel.frame.maxX
        let appendX = self.appendLabel.frame.maxX
        
        //没出格不能换
        if scroX > 0 && appendX > 0{
            return
        }
        
        //间距太小 不能换
        if ys_maxSuperW - scroX < labelSpace || ys_maxSuperW - appendX < labelSpace{
            return
        }
        
        if scroX < appendX {
            self.scroLabel.frame = CGRect(x: ys_maxSuperW, y: self.scroLabel.frame.origin.y, width: self.scroLabel.frame.width, height: self.scroLabel.frame.height)
        }else{
            self.appendLabel.frame = CGRect(x: ys_maxSuperW, y: self.scroLabel.frame.origin.y, width: self.scroLabel.frame.width, height: self.scroLabel.frame.height)
        }
    }
    
    func adsSetup(){
        guard let thisAds = ads else {return}
        var titles: [String] = []
        var images: [String] = []
        for item in thisAds {
            titles.append(item.slide_title ?? "")
            images.append(item.slide_image_path ?? "")
        }
//        adView.titles = titles
        adView.imagePaths = images
    }
    
    
    func setupAnimate() {
        scroLabel.text = self.noticeStr
        appendLabel.text = self.noticeStr
        
        setLabelFrame()
        
        timer = DispatchSource.timer(interval: .milliseconds(50), queue: DispatchQueue.main) { [unowned self] in
            if self.appendLabel.frame.width != self.scroLabel.frame.width {
                self.appendLabel.setwidth(w: self.scroLabel.frame.width)
            }
            self.scroLabel.moveX(x: -1)
            self.appendLabel.moveX(x: -1)
            
            let ys_maxX = self.scroLabel.frame.maxX
            let ys_maxX0 = self.appendLabel.frame.maxX
            
            let ys_minX = self.scroLabel.frame.minX
            let ys_minX0 = self.appendLabel.frame.minX
            
            if ys_maxX < 0 && ys_minX0 < 0{
                //已出
                self.resetFrame()
                return
            }
            
            
            if ys_maxX0 < 0 && ys_minX < 0{
                //已出
                self.resetFrame()
                return
            }
            
        }
    }
}

extension YSHomeHeadView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eightTitles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSHomeEightCollectionViewCell", for: indexPath) as! YSHomeEightCollectionViewCell
        cell.ys_titleLabel.text = eightTitles[indexPath.item]
        cell.ys_imageView.image = UIImage(named: eightTitles[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let titleStr = eightTitles[indexPath.item]
        var vc:RootViewController? = nil
        switch titleStr {
        case "群主公告":
            vc = YSAnnounceViewController()
        case "物业人事":
            vc = YSPersonViewController()
        case "民意投票":
            vc = YSVoteViewController()
        case "小区公约":
            vc = YSPactViewController()
        default:
            return
        }
        vc?.hidesBottomBarWhenPushed = true
        guard let superVc = self.superVc(),vc != nil else {return}
        
        superVc.navigationController?.pushViewController(vc!, animated: true)
    }
}


