//
//  YSHomeHeadView.swift
//  YuShu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 coderX. All rights reserved.
//

import UIKit
import pop
let num: CGFloat = 4
let itemW = (KScreenWidth - (num + 1) * 10)/num
class YSHomeHeadView: UIView {
    var timer: DispatchSourceTimer?
    let eightTitles = ["","","","","","","",""]
    var notices = ["xxxx","xxx","xxx","xxx"] {
        didSet{
            self.setupAnimate()
        }
    }
    @IBOutlet weak var ys_adsuperView: UIView!
    
    @IBOutlet weak var ys_showView: UIView!
    @IBOutlet weak var ys_collectionView: UICollectionView!
    
    @IBOutlet weak var ys_tableView: UITableView!
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
        ys_collectionView.register(str: "YSHomeCollectionViewCell")
        ys_tableView.register(str: "YSHomeShowTableViewCell")
    }
    
    func setupAnimate() {
        var row = 0
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(1))
        timer?.setEventHandler {
            if row == self.notices.count - 1 {
                row = 0
            }
            DispatchQueue.main.async {
                if row < self.notices.count {
                    let indexP = IndexPath(row: row, section: 0)
                    self.ys_tableView.scrollToRow(at: indexP, at: .top, animated: true)
                }
               
            }
            row += 1

        }
        if #available(iOS 10.0, *) {
            timer?.activate()
        }else{
            timer?.resume()
        }
    }
}

extension YSHomeHeadView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eightTitles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YSHomeCollectionViewCell", for: indexPath) as! YSHomeCollectionViewCell
        return cell
    }
}

extension YSHomeHeadView: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.ys_showView.frame.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YSHomeShowTableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
